class UsersController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    @users = User.includes(:profile)
  end

  def show
    @user = User.find(params[:id])
    @profile = @user.profile
    @tasks = Task.where(user_id: @user.id).order("created_at DESC")
  end
end
