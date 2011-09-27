class Video < ActiveRecord::Base
  cattr_accessor :viddler
  belongs_to :user
  belongs_to :session

  validates :video_id, :uniqueness => {:case_sensitive => false}, :presence => true
  validates :title, :presence => true, :length => {:maximum => 140}, :on => :update
  validates_associated :user, :on => :update

  accepts_nested_attributes_for :user

  scope :published, where("published_at IS NOT NULL")
  scope :authenticated, where("user_id IS NOT NULL")

  after_destroy :delete_video

  class Viddler
    cattr_accessor :session
    class << self
      
      def authenticate!
        @@session = ::Viddler::Client.new(::ViddlerApp::Viddler.api_key)
        @@session.xauthenticate! ::ViddlerApp::Viddler.user, ::ViddlerApp::Viddler.password, :get_record_token => "1"
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
  
  def to_param
    self.video_id
  end
  
  def viddler
    Video::Viddler.session
  end
  
  def delete_video
    result = self.viddler.post 'viddler.videos.delete', 
      :sessionid => self.viddler.sessionid, :video_id => self.video_id
    !!result['success']
  rescue Viddler::ApiException
    false
  end
  
  def sync_attributes!
    result = self.viddler.get 'viddler.videos.getDetails', :video_id => self.video_id
    self.title ||= result['video']['title']
    self.description ||= result['video']['description']
    self.url ||= result['video']['url']
    self.thumbnail_url ||= result['video']['thumbnail_url']
    result
  end
  
end
