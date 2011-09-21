class Video < ActiveRecord::Base
  extend FriendlyId
  attr_accessor :file

  belongs_to :user
  belongs_to :session

  validate :source, :presence => true
  validate :video_id, :uniqueness => true, :presence => true
  validates_presence_of :title, :file, :if => :upload?
  validates_associated :user, :if => :upload?
  validate :slug, :uniqueness => true, :presence => true
  friendly_id :video_id

  accepts_nested_attributes_for :user

  before_validation :remove_user_if_webcam_source
  
  def webcam?
    self.source && !!self.source.match(/^webcam/i)
  end
  
  def upload?
    self.source && !!self.source.match(/^upload/i)
  end
  
  protected
  
  def remove_user_if_webcam_source
    self.user = nil if self.webcam?
  end
  
end
