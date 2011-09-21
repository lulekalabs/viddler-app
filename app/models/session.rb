class Session < ActiveRecord::Base
  belongs_to :user
  validates :session_id, :uniqueness => {:case_sensitive => false}
end
