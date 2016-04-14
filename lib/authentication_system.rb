module AuthenticationSystem
  def current_user=(new_user)
    session[:user_id] = new_user ? new_user.id : nil
    @current_user = new_user || false
    @current_user
  end

  def current_user
    @current_user ||= login_from_session unless @current_user == false
    @current_user
  end

  def login_required
    logged_in? || access_denied
  end

  def logged_in?
    current_user
  end

  def access_denied
    respond_to do |format|
      format.html { redirect_to new_sessions_path }
    end
  end

  def login_from_session
    self.current_user = User.find_by_id(session[:user_id]) if session[:user_id]
  end
end
