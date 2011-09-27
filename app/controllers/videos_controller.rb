class VideosController < ApplicationController
  respond_to :html, :js
  before_filter :viddler_authenticate
  before_filter :get_record_token
  before_filter :prepare_upload
  before_filter :find_video, :only => [:show, :edit, :update, :delete]
  before_filter :find_videos, :only => :list
  before_filter :build_user, :only => [:edit, :update]
  before_filter :build_video, :only => [:new, :index, :create, :uploaded]
  
  def index
    # nothing to do here
  end

  def list
    render :layout => false
  end
  
  def create
    @video.save
    respond_with(@video, :layout => !request.xhr?)
  end
  
  def update
    @video.attributes = video_params.merge(:user => @user)
    @video.save and @video.user.save
    respond_with @video
  end
  
  def delete
    result = @viddler.post 'viddler.videos.delete', :sessionid => @viddler.sessionid, 
      :video_id => params[:id]
    if result['success']
      Video.destroy_all(:video_id => params[:id])
      find_videos and render :template => "videos/list", :layout => false
    else
      render :status => :unprocessable_entity
    end
  end
  
  # viddler callback after file upload
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
  
  def find_videos
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
    @video = Video.instance_for({:source => "upload", :session => @session}.merge(video_params.merge(:user => @user)))
  end
  
  def find_video
    if @video = Video.find_by_video_id(params[:id])
      @user = @video.user
    else
      render :template => "videos/not_found"
      return false
    end
  end
end
