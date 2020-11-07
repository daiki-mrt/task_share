class RelationshipsController < ApplicationController
  def create
    follow = current_user.active_relationships.new(follower_id: params[:user_id])
    if follow.save
      redirect_to user_path(params[:user_id])
    else
      redirect_to user_path(params[:user_id])
    end
  end

  def destroy
    follow = current_user.active_relationships.find_by(follower_id: params[:user_id])
    if follow.destroy
      redirect_to user_path(params[:user_id])
    else
      redirect_to user_path(params[:user_id])
    end
  end
end
