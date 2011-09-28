class User < ActiveRecord::Base
  has_many :sessions, :dependent => :destroy
  has_many :videos, :dependent => :destroy

  validates_presence_of :name, :email
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_acceptance_of :terms
  validate :email, :uniqueness => {:case_sensitive => false}
  
  scope :recent, order("created_at desc").limit(10)
  
end
