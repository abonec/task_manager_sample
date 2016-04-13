class SessionsController < ApplicationController
  def create
    self.current_user = User.authenticate params[:email], params[:password]
    redirect_url = logged_in? ? tasks_path : new_sessions_path
    redirect_to redirect_url
  end
end
