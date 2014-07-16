class Session < ActiveRecord::Base
  belongs_to :user
  has_many :videos
  validates :session_id, :uniqueness => {:case_sensitive => false}
  
  def videos
    scoped = Video.scoped
    vds = Video::Viddler.hashed_videos
    scoped = scoped.where("videos.video_id IN (?)", vds.keys)
    scoped
  end
  
end
