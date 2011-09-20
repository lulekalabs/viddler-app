class VideosController < ApplicationController
  before_filter :get_session
  before_filter :get_record_token
  
  def index
    # home page
  end

  def list
    load_videos and render :layout => false
  end
  
  def delete
    result = @viddler.post 'viddler.videos.delete', :sessionid => @viddler.sessionid, 
      :video_id => params[:id]
    if result['success']
      load_videos and render :template => "videos/list", :layout => false
    else
      render :status => :unprocessable_entity
    end
  end
  
  protected
  
  def get_record_token
    @record_token = @viddler.session['record_token']
  end
  
  def load_videos
    result = @viddler.get 'viddler.videos.getByUser', :user => @viddler_user, :per_page => 100
    @videos = result['list_result']['video_list']
  end
end
