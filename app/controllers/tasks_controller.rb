class TasksController < ApplicationController
  before_filter :login_required
  before_filter :find_task, only: [:edit, :show]
  def index
    @tasks = current_user.tasks
    render text: current_user.email
  end

  def edit
    render text: @task.name
  end

  def show
    render text: @task.name
  end

  private
  def find_task
    @task = current_user.tasks.where(id: params[:id]).first
    redirect_to tasks_path unless @task
  end
end
