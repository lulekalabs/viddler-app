class User < ActiveRecord::Base
  has_many :sessions
  has_many :videos

  validates_presence_of :name, :email
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_acceptance_of :terms
  validates :email, :uniqueness => {:case_sensitive => false}
end
