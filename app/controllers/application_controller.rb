class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  
  def get_session
    @viddler_api_key  = "17yncitdjk2bn1zfjiry"
    @viddler_user     = "bvision"
    @viddler_password = "sanfran415"
    @viddler          = Viddler::Client.new(@viddler_api_key)
    @viddler_session  = @viddler.get('viddler.users.auth', 
      :api_key => @viddler_api_key, :user => @viddler_user, :password => @viddler_password, :get_record_token => "1")
  end
end
