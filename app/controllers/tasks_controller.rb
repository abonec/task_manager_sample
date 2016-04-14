class TasksController < ApplicationController
  before_filter :login_required
  before_filter :find_task, only: [:edit, :show, :update, :destroy]
  def index
    @tasks = current_user.admin? ? Task.all : current_user.tasks
  end

  def new
    @task = Task.new
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
  end

  def show
  end

  def destroy
    @task.destroy
    redirect_to tasks_path
  end

  private

  def find_task
    @task = Task.for(current_user).find_by id: params[:id]
    redirect_to tasks_path unless @task
  end

  def task_params
    params.require(:task).permit(:name, :description, :file)
  end
end
