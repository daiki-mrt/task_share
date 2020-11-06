class TasksController < ApplicationController
  def new
    set_user
    set_profile
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.valid?
      @task.save
      redirect_to user_path(current_user)
    else
      set_user
      set_profile
      render :new
    end
  end

  private
  def set_user
    @user = User.find(params[:user_id])
  end

  def set_profile
    @profile = @user.profile
  end

  def task_params
    params.require(:task).permit(:title, :text).merge(user_id: current_user.id)
  end
end
