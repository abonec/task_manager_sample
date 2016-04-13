module AuthenticationSystem
  def current_user=(new_user)
    session[:user_id] = new_user ? new_user.id : nil
    @current_user = new_user || false
    @current_user
  end

  def current_user
    unless @current_user == false
      @current_user ||= login_from_session
    end
    @current_user
  end

  def logged_in?
    !!current_user
  end

  def login_from_session
    self.current_user = User.find_by_id(session[:user_id]) if session[:user_id]
    raise 'need to check this code'
  end
end