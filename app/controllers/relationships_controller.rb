class RelationshipsController < ApplicationController
  def create
    follow = current_user.active_relationships.new(follower_id: params[:user_id])
    redirect_to user_path(params[:user_id]) if follow.save
  end

  def destroy
    follow = current_user.active_relationships.find_by(follower_id: params[:user_id])
    redirect_to user_path(params[:user_id]) if follow.destroy
  end
end
