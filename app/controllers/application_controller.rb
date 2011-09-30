class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :session_required
  
  protected
  
  def viddler_authenticate
    @viddler = Video::Viddler.authenticate!
  end
  
  def session_required
    unless !!current_session
      self.current_session = Session.find_or_create_by_session_id(session[:session_id]) do |session|
        session.ip = request.ip
        session.user_agent = request.user_agent
      end
    end
  end

  def current_session
    @current_session ||= (session_from_session || session_from_cookie) unless @current_session == false
  end
  helper_method :current_session

  def current_session=(new_session)
    session[session_param] = new_session ? new_session.session_id : nil
    cookies[cookie_auth_token] = {:value => new_session ? new_session.session_id : nil, :expires => Time.now + 1.year}
    @current_session = new_session || false
  end

  def session_from_session
    self.current_session = Session.find_by_session_id(session[session_param]) if session[session_param]
  end

  def session_from_cookie
    session = cookies[cookie_auth_token] && Session.find_by_session_id(cookies[cookie_auth_token])
    if session
      cookies[cookie_auth_token] = {
        :value => session.session_id,
        :expires => Time.now + 1.year
        # :domain => "domain.com"
      }
      self.current_session = session
    end
  end
  
  def session_param
    :canonical_session
  end
  
  def cookie_auth_token
    "#{session_param}_auth_token".to_sym
  end
  
end
