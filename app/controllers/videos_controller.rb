class VideosController < ApplicationController
  before_filter :get_session
  before_filter :get_record_token
  before_filter :prepare_upload
  before_filter :load_video, :only => [:show, :edit, :update]
  before_filter :build_user, :only => [:edit, :update]
  before_filter :build_video, :only => [:new, :index, :create, :uploaded]
  
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
  
  def update
    @video.attributes = video_params.merge(:user => @user)
    @video.save and @video.user.save
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
  
  # callback viddler
  def uploaded
    @video.video_id = params[:videoid]
    if @video.save
      redirect_to edit_video_path(@video), :notice => I18n.t(:video_upload_success)
    else
      redirect_to "/", :alert => I18n.t(:video_upload_error)
    end
  end
  
  protected
  
  def get_record_token
    @record_token = @viddler.session['record_token']
  end
  
  def load_videos
    if false
      @videos = Video.all
    else
      result = @viddler.get 'viddler.videos.getByUser', :per_page => 100
      @videos = []
      result['list_result']['video_list'].each do |video|
        @videos << Video.new(:video_id => video['id'], :title => video['title'], :description => video['description'],
          :url => video['url'], :thumbnail_url => video['thumbnail_url'])
      end
      @videos
    end
  end

  def video_params
    @video_params ||= (params[:video] || params[:recorded_video] || params[:uploaded_video] || {}).symbolize_keys
  end

  def build_user
    @user ||= User.new video_params.delete(:user) || {}
  end
  
  def prepare_upload
    upload = @viddler.get 'viddler.videos.prepareUpload'
    @video_upload_url = upload['upload']['endpoint']
    @video_upload_token = upload['upload']['token']
  end
  
  def build_video
    @video = Video.instance_for({:source => "upload", :session => @session, :viddler => @viddler}.merge(video_params.merge(:user => @user)))
  end
  
  def load_video
    @video = Video.find_by_video_id(params[:id])
    @user = @video.user
  end
end
