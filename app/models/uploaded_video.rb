class UploadedVideo < Video
  attr_accessor :file
  validates_presence_of :title, :file
  validates_associated :user, :on => :create
  validate :title, :uniqueness => true
  
  before_save :upload

  def self.source; :upload; end
  
  protected

  def upload
    if self.upload?
      # upload to viddler!
      result = self.viddler.upload(self.file, :title => self.title, 
        :description => self.title, :tags => self.title)
      if result['error']
        self.errors.add(:file, result['error'].to_s)
        return false
      else
        self.attributes = {
          :video_id => result['video']['id'], 
          :url => result['video']['url'], 
          :thumbnail_url => result['video']['thumbnail_url'], 
          :description => result['video']['description'], 
          :tags => result['video']['tags']
        }
        return true
      end
    end
  end
  
end