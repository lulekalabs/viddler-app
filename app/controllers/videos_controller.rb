class VideosController < ApplicationController
  before_filter :get_session
  before_filter :get_record_token
  before_filter :build_user, :only => [:new, :index, :create]
  before_filter :build_video, :only => [:new, :index, :create]
  
  def index
    # nothing to do here
  end

  def list
    load_videos and render :layout => false
  end
  
  def new
    render :layout => !request.xhr?
  end
  
  def create
    @video.save
    respond_to do |format|
      format.js
    end
  end
  
  def delete
    result = @viddler.post 'viddler.videos.delete', :sessionid => @viddler.sessionid, 
      :video_id => params[:id]
    if result['success']
      Video.destroy_all(:video_id => params[:id])
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
    result = @viddler.get 'viddler.videos.getByUser', :per_page => 100
    @videos = result['list_result']['video_list']
  end

  def video_params
    (params[:video] || params[:recorded_video] || params[:uploaded_video] || {}).symbolize_keys
  end

  def build_user
    @user = User.new video_params.delete(:user) || {}
  end
  
  def build_video
    @video = Video.instance_for({:source => "upload", :session => @session, :viddler => @viddler}.merge(video_params.merge(:user => @user)))
  end
end
