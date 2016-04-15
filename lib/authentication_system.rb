module AuthenticationSystem

  def self.included(base)
    base.send :helper_method, :current_user, :logged_in?, :is_admin? if base.respond_to? :helper_method
  end

  def authenticate(email, password)
    self.current_user = User.authenticate email, password
  end
  def current_user=(new_user)
    session[:user_id] = new_user ? new_user.id : nil
    @current_user = new_user || false
    @current_user
  end

  def current_user
    @current_user ||= login_from_session
  end

  def login_required
    logged_in? || access_denied
  end

  def admin_required
    (login_required && is_admin?) || admin_access_denied
  end

  def logged_in?
    current_user
  end

  def is_admin?
    logged_in? && current_user.admin?
  end

  def access_denied
    respond_to do |format|
      format.html { redirect_to new_sessions_path }
    end
  end

  def admin_access_denied
    respond_to do |format|
      format.html { redirect_to tasks_path }
      format.json { render json: { error: :permission_denied } }
    end
  end

  def login_from_session
    self.current_user = User.find_by_id(session[:user_id]) if session[:user_id]
  end
end
