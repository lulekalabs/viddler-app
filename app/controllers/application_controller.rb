class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :find_or_store_session
  
  protected
  
  def get_session
    @viddler = Viddler::Client.new(ViddlerApp::Viddler.api_key)
    @viddler.xauthenticate! ViddlerApp::Viddler.user, ViddlerApp::Viddler.password, :get_record_token => "1"
  end
  
  def find_or_store_session
    @session = Session.find_or_create_by_session_id(session[:session_id]) do |session|
      session.ip = request.ip
      session.user_agent = request.user_agent
    end
  end
  
end
