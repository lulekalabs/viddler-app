class VotesController < ApplicationController
  before_filter :find_video

  def create
    respond_to do |format|
      format.json do
        @vote = Vote.new(:video => @video, :session => current_session, :points => 1)
        if @vote.valid?
          render :json => @vote, :status => :created
        else
          logger.debug @vote.errors.inspect
          render :json => @vote.errors, :status => :unprocessable_entity
        end
      end
    end
  end

  protected
  
  def find_video
    if @video = Video.find_by_video_id(params[:video_id])
      @user = @video.user
    else
      return false
    end
  end
  
end
