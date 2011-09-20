class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  
  def get_session
    @viddler = Viddler::Client.new(ViddlerApp::Viddler.api_key)
    @viddler.xauthenticate! ViddlerApp::Viddler.user, ViddlerApp::Viddler.password, :get_record_token => "1"
    # @viddler_session  = @viddler.get('viddler.users.auth', 
    #   :api_key => ViddlerApp::Viddler.api_key, 
    #   :user => ViddlerApp::Viddler.user, 
    #   :password => ViddlerApp::Viddler.password, 
    #   :get_record_token => "1"
    # )
  end
end
