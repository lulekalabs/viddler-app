class VideosController < ApplicationController
  respond_to :html, :js, :json
  before_filter :viddler_authenticate
  before_filter :get_record_token
  before_filter :prepare_upload
  before_filter :find_video, :only => [:show, :edit, :update, :delete]
  before_filter :authentication_required, :only => [:edit, :update]
  before_filter :build_user, :only => [:edit, :update]
  before_filter :build_video, :only => [:new, :index, :create, :uploaded]
  after_filter :update_current_session_with_user, :only => :update
  
  def index
    # nothing to do here
  end

  def create
    @video.sync_attributes!
    @video.save
    respond_with(@video, :layout => !request.xhr?)
  end
  
  def update
    @video.attributes = video_params.merge(:user => @user)
    @video.save and @video.user.save
    respond_with @video
  end
  
  def delete
    @video.destroy
    respond_with @video
  end
  
  # viddler callback after file upload
  def uploaded
    @video.video_id = params[:videoid]
    @video.sync_attributes!
    if @video.save
      redirect_to edit_video_path(@video), :notice => I18n.t(:upload_success)
    else
      redirect_to "/", :alert => I18n.t(:upload_error)
    end
  end
  
  def recent
    @videos = current_session.videos.published.recent
    render :template => "videos/list", :layout => false
  end

  def popular
    @videos = current_session.videos.published.popular
    render :template => "videos/list", :layout => false
  end

  def my
    @videos = current_session.videos.my(current_session)
    render :template => "videos/list", :layout => false
  end
  
  protected
  
  def get_record_token
    @record_token = @viddler.session['record_token']
  end
  
  def find_videos
    @videos = current_session.videos
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
  
  def find_video
    if @video = Video.find_by_video_id(params[:id])
      @user = @video.user
    else
      render :template => "videos/not_found"
      return false
    end
  end
  
  def build_video
    @video = Video.instance_for({:source => "upload", :session => current_session}.merge(video_params.merge(:user => @user)))
  end
  
  def update_current_session_with_user
    if @video && @video.session == current_session && @video.user && @video.user.errors.blank?
      current_session.update_attribute(:user, @video.user)
    end
  end

  def authentication_required
    if @video && (@video.registered? || @video.session != current_session)
      redirect_to video_path(@video), :status => :moved_permanently
    end
  end
  
end
