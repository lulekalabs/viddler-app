class Vote < ActiveRecord::Base
  belongs_to :video
  belongs_to :session
  delegate :user, :to => :session
  validates :points, :presence => true
  validate :ensure_unique_vote
  
  after_create :update_votes_sum

  protected
  
  def update_votes_sum
    self.video.class.update_counters(self.video.id, :votes_sum => self.points, :votes_count => 1)
  end
  
  def ensure_unique_vote
    if Vote.joins(:session, :video).
      where("sessions.id" => self.session.id).
      where("videos.id" => self.video.id).count > 0
        errors.add(:session, "already voted")
    end
  end
end
