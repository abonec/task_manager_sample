class TasksController < ApplicationController
  before_filter :login_required
  before_filter :find_task, only: [:edit, :show, :update]
  def index
    @tasks = current_user.tasks
    render text: current_user.email
  end

  def create
    @task = current_user.tasks.new task_params
    if @task.save
      redirect_to @task
    else
      render :new
    end
  end

  def update
    if @task.update_attributes(task_params)
      redirect_to @task
    else
      render :edit
    end
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

  def task_params
    params.require(:task).permit(:name, :description)
  end
end
