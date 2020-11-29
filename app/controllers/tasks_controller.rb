class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :move_to_index, except: :index

  def index
    set_user
    @tasks = Task.user_is(params[:user_id]).completed
  end

  def new
    set_user
    set_profile
    @task = Task.new
    @following_users = @user.followings
    @follower_users = @user.followers
  end

  def create
    @task = Task.new(task_params)
    if @task.valid?
      @task.save
      redirect_to user_path(current_user)
    else
      set_user
      set_profile
      # サイドバー情報の取得(フォロー)
      @following_users = @user.followings
      @follower_users = @user.followers  
      # サイドバー情報の取得(メッセージ)
      room_ids = current_user.user_rooms.pluck(:room_id)
      @target_user_room = UserRoom.find_by(room_id: room_ids, user_id: @user.id)
      @room = @target_user_room.room if @target_user_roo
      # 投稿タスク一覧取得
      @tasks = Task.user_is(@user.id).not_completed.order("created_at DESC")

      render "users/show"
    end
  end

  def edit
    set_user
    set_profile
    set_task
    @following_users = @user.followings
    @follower_users = @user.followers
  end

  def update
    set_task
    if @task.update(task_params)
      redirect_to user_path(current_user)
    else
      set_user
      set_profile
      render :edit
    end
  end

  def destroy
    set_task
    redirect_to user_path(current_user) if @task.destroy
  end

  def done
    set_task
    @task.update(state: 1)
    redirect_to request.referer
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_profile
    @profile = @user.profile
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :text).merge(user_id: current_user.id)
  end

  def move_to_index
    set_user
    redirect_to "/" unless user_signed_in? && (current_user.id == @user.id)
  end
end
