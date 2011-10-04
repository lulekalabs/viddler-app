require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  fixtures :all

  test "should add a vote" do
    vote = Vote.create!(:session => sessions(:marie), :video => videos(:sweet_maria), :points => 3)
    vote.video.reload
    assert_equal 1, vote.video.votes_count
    assert_equal 3, vote.video.votes_sum
  end
  
  test "should vote only once per video" do
    vote = Vote.new(:session => sessions(:ken), :video => videos(:kenya))
    assert_error_on vote, :session
  end

  test "should vote once on multiple videos" do
    vote = Vote.new(:session => sessions(:ken), :video => videos(:sweet_maria))
    assert_no_error_on vote, :session
  end
  
  test "should reset vote counters on destroy" do
    vote = Vote.create!(:session => sessions(:ken), :video => videos(:sweet_maria), :points => 2)
    videos(:sweet_maria).reload
    assert_equal 1, videos(:sweet_maria).votes_count
    assert_equal 2, videos(:sweet_maria).votes_sum
    vote.destroy
    videos(:sweet_maria).reload
    assert_equal 0, videos(:sweet_maria).votes_count
    assert_equal 0, videos(:sweet_maria).votes_sum
  end
end
