class LikesController < ApplicationController
  before_action :task_params

  def create
    @like = Like.new(like_params)
    @like.save
    @task = @like.task
  end

  def destroy
    like = Like.find_by(user_id: current_user.id, task_id: params[:task_id])
    like.destroy
  end

  private

  def like_params
    params.permit(:task_id).merge(user_id: current_user.id)
  end

  def task_params
    @task = Task.find(params[:task_id])
  end
end
