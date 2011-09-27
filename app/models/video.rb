class Video < ActiveRecord::Base
  cattr_accessor :viddler
  belongs_to :user
  belongs_to :session

  validates :video_id, :uniqueness => {:case_sensitive => false}, :presence => true
  validates :title, :presence => true, :length => {:maximum => 140}, :on => :update
  validates_associated :user, :on => :update

  accepts_nested_attributes_for :user

  after_destroy :delete_video

  class << self

    def instance_for(attributes = {})
      record = new attributes
      record
    end
    
    def viddler
      @viddler ||= begin
        v = Viddler::Client.new(ViddlerApp::Viddler.api_key)
        v.xauthenticate! ViddlerApp::Viddler.user, ViddlerApp::Viddler.password, :get_record_token => "1"
        v
      end
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
    self.class.viddler
  end
  
  def delete_video
    result = self.viddler.post 'viddler.videos.delete', 
      :sessionid => self.viddler.sessionid, :video_id => self.video_id
    !!result['success']
  rescue Viddler::ApiException
    false
  end
  
end
