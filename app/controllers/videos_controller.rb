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
    respond_to do |format|
      if @video.valid?
        if @video.upload?
          # upload to viddler!
          result = @viddler.upload(@video.file, :title => @video.title, :description => @video.title, :tags => @video.title)
          unless result['error']
            @video.attributes = {:video_id => result['video']['id'], :url => result['video']['url'], 
              :thumbnail_url => result['video']['thumbnail_url'], :description => result['video']['description'], 
                :user => @user, :session => @session}
            @video.save!
          end
        elsif @video.webcam?
          @video.attributes = {:session => @session, :user => nil}
          @video.save!
        end
      end
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

  def build_user
    user_attributes = (params[:video] || {}).delete(:user) || {}
    @user = User.new user_attributes
  end
  
  def build_video
    @video = Video.new (params[:video] || {}).merge(:user => @user)
  end
end
