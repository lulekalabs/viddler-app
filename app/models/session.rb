class Session < ActiveRecord::Base
  belongs_to :user
  validates :session_id, :uniqueness => {:case_sensitive => false}
  
  def videos
    if true
      Video.published.where("videos.user_id IS NOT NULL OR videos.session_id = ?", self.id)
    else
      vd_videos = Video::Viddler.hashed_videos
      db_videos = Video.published.where("videos.user_id IS NOT NULL OR videos.session_id = ?", self.id)
      db_videos.each do |db_video|
        if vd_video = vd_videos[db_video.id]
          db_video.name = db_video.name || vd_video.name
          db_video.description = db_video.description || vd_video.description
          db_video.thumbnail_url = vd_video.thumbnail_url# || db_video.thumbnail_url
          db_video.url = vd_video.url || db_video.url
        end
      end
      db_videos
    end
  end
  
end
