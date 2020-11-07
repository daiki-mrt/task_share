class UsersController < ApplicationController
  before_action :set_user, only: [:show, :follows, :followers]

  def index
    @users = User.includes(:profile)
  end

  def show
    set_user
    @tasks = Task.where(user_id: @user.id).order("created_at DESC")
    @following_users = @user.followings
    @follower_users = @user.followers
  end

  # フォロー数
  def follows
    set_user
    @following_users = @user.followings
  end

  # フォロワー数
  def followers
    set_user
    @follower_users = @user.followers
  end


  private
  def set_user
    @user = User.find(params[:id])
    @profile = @user.profile
  end

end
