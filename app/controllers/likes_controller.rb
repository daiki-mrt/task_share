class LikesController < ApplicationController
  def create
    @like = Like.new(like_params)
    if @like.save
      redirect_to request.referer
    else
      redirect_to request.referer
    end
  end

  def destroy
    like = Like.find_by(user_id: current_user.id, task_id: params[:task_id])
    like.destroy
    redirect_to request.referer
  end

  private
  def like_params
    params.permit(:task_id).merge(user_id: current_user.id)
  end
end
