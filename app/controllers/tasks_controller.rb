class TasksController < ApplicationController
  before_filter :login_required
  def index
    @tasks = current_user.tasks
    render text: current_user.email
  end
end
