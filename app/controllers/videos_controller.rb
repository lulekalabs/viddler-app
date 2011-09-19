class VideosController < ApplicationController

  before_filter :get_session
  before_filter :get_record_token
  
  def index
  end

  def list
    result = @viddler.get 'viddler.videos.getByUser', :user => @viddler_user, :per_page => 100
    @videos = result['list_result']['video_list']
    render :layout => false
  end
  
  protected
  
  def get_record_token
    @record_token = @viddler_session['auth']['record_token']
  end
end
