class Video < ActiveRecord::Base
  attr_accessor :viddler
  belongs_to :user
  belongs_to :session

  validates :video_id, :uniqueness => {:case_sensitive => false}, :presence => true
  validates :title, :presence => true, :length => {:maximum => 140}, :on => :update
  validates_associated :user, :on => :update

  accepts_nested_attributes_for :user

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
  
end
