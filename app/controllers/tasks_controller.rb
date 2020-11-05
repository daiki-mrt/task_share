class TasksController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @task = Task.new
  end

  def create
    
  end
end
