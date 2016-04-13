class SessionsController < ApplicationController
  before_filter :extract_credentials, only: :create
  attr_reader :credentials

  def create
    self.current_user = User.authenticate credentials[:email], credentials[:password]
    if logged_in?
      redirect_to tasks_path
    else
      flash[:error] = I18n.t('sessions.user_not_found')
      redirect_to new_sessions_path
    end
  end

  def new

  end

  private

  def extract_credentials
    @credentials = params[:sessions]
    if @credentials.values.any?(&:blank?)
      flash[:error] = I18n.t('sessions.please_enter_credentials')
      return redirect_to new_sessions_path
    end
  end
end
