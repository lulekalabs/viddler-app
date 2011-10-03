require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  fixtures :all

  test "should add a vote" do
    vote = Vote.create!(:session => sessions(:marie), :video => videos(:sweet_maria), :points => 3)
    vote.video.reload
    assert_equal 1, vote.video.votes_count
    assert_equal 3, vote.video.votes_sum
  end
  
  test "should vote only once per campaign" do
    vote = Vote.new(:session => sessions(:ken), :video => videos(:kenya))
    assert_error_on vote, :user
  end
end