class Video < ActiveRecord::Base
  belongs_to :user
  belongs_to :session
  has_many :votes, :dependent => :destroy
  has_many :voters, :through => :votes, :source => :session

  validates :video_id, :uniqueness => {:case_sensitive => false}, :presence => true
  validates :title, :presence => true, :length => {:maximum => 140}, :on => :update
  validates_associated :user, :on => :update

  accepts_nested_attributes_for :user

  extend FriendlyId
  friendly_id :video_id, :use => :slugged

  scope :published, where("videos.published_at IS NOT NULL")
  scope :unpublished, where("videos.published_at IS NULL AND videos.user_id IS NOT NULL")
  scope :registered, where("videos.user_id IS NOT NULL")
  scope :recent, order("videos.created_at DESC")
  scope :popular, order("videos.votes_sum DESC")
  scope :my, lambda {|su| su.is_a?(Session) ? where("videos.session_id = ?", su.id) : where("videos.user_id = ?", su.id)}

  after_destroy :delete_on_viddler

  class Viddler
    cattr_accessor :session
    class << self
      
      def authenticate!
        @@session ||= begin
          session = ::Viddler::Client.new(::ViddlerApp::Viddler.api_key)
          session.xauthenticate! ::ViddlerApp::Viddler.user, ::ViddlerApp::Viddler.password, :get_record_token => "1"
          session
        end
      end
      
      def session
        @@session
      end
      
      # [{'id' => "234234e2", 'title' => ...}, ...]
      def videos
        result = @@session.get 'viddler.videos.getByUser', :per_page => 100
        result['list_result']['video_list'] || []
      end
      
      # {"234234e2" => {'id' => "234234e2", 'title' => ...}, ...}
      def hashed_videos
        videos.inject({}) do |h, v|
          h[v['id']] = v
          h
        end
      end
      
    end
  end

  class << self

    def instance_for(attributes = {})
      record = new attributes
      record
    end
    
  end

  def webcam?
    self.source == 'webcam'
  end

  def upload?
    self.source == 'upload'
  end
  
  def delete_on_viddler
    Video::Viddler.authenticate!
    result = Video::Viddler.session.post 'viddler.videos.delete', 
      :sessionid => Video::Viddler.session.sessionid, :video_id => self.video_id
    !!result['success']
  rescue ::Viddler::ApiException
    false
  end
  
  def sync_attributes!
    result = false
    if self.video_id
      result = Video::Viddler.session.get 'viddler.videos.getDetails', :video_id => self.video_id
      self.title ||= result['video']['title']
      self.description ||= result['video']['description']
      self.url ||= result['video']['url']
      self.thumbnail_url ||= result['video']['thumbnail_url']
    end
    result
  end
  
  def published?
    !!self.published_at
  end
  
  def registered?
    !!self.user
  end

  def human_source_name
    webcam? ? I18n.t("videos.recorded_video") : I18n.t("videos.uploaded_video")
  end

  def human_status_name
    if self.published?
      I18n.t("videos.status.published")
    elsif self.registered?
      I18n.t("videos.status.registered")
    else
      I18n.t("videos.status.created")
    end
  end

  def voted?(session)
    self.voters.where("sessions.id" => session.id).count > 0
  end
  
end
