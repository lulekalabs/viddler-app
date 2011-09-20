module Viddler
  module Extension

    attr_accessor :session

    def xauthenticate!(username, password, options = {})
      auth = get 'viddler.users.auth', options.merge(:user => username, :password => password)
      self.session = auth['auth']
      self.sessionid = self.session['sessionid']
    end
    
  end
end
Viddler::Client.send :include, Viddler::Extension