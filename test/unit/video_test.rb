require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  fixtures :all
  
  test "should be valid" do
    assert videos(:kenya).valid?
  end

  test "should be valid on create" do
    assert Video.new(:video_id => "abcdefg").valid?
  end
  
  %w(video_id title user session).each do |attribute|
    test "should be invalid without #{attribute}" do
      video = Video.new videos(:kenya).attributes
      video.send "#{attribute}=", nil
      assert !video.valid?
    end
  end
end
