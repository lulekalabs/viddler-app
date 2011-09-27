class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :find_or_store_session
  
  protected
  
  def viddler_authenticate
    @viddler = Video::Viddler.authenticate!
  end
  
  def find_or_store_session
    @session = Session.find_or_create_by_session_id(session[:session_id]) do |session|
      session.ip = request.ip
      session.user_agent = request.user_agent
    end
  end
  
end
