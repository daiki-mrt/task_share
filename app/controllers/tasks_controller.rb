class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, except: [:destroy, :done]
  before_action :set_task, only: [:edit, :update, :destroy, :done]
  # フォロー・フォロワー（サイドバー）
  before_action :set_user_relationships, only: [:new, :create, :edit, :update]
  before_action :move_to_index, except: :index

  def index
    @tasks = @user.tasks.completed
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.valid?
      @task.save
      redirect_to user_path(current_user)
    else
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
  end

  def update
    if @task.update(task_params)
      redirect_to user_path(current_user)
    else
      # サイドバー情報の取得(メッセージ)
      room_ids = current_user.user_rooms.pluck(:room_id)
      @target_user_room = UserRoom.find_by(room_id: room_ids, user_id: @user.id)
      @room = @target_user_room.room if @target_user_roo
      # 投稿タスク一覧取得
      @tasks = Task.user_is(@user.id).not_completed.order("created_at DESC")

      render :edit
    end
  end

  def destroy
    redirect_to user_path(current_user) if @task.destroy
  end

  def done
    @task.update(state: 1)
    redirect_to request.referer
  end

  private

  def set_user
    @user = User.find(params[:user_id])
    @profile = @user.profile
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def set_user_relationships
    @following_users = @user.followings
    @follower_users = @user.followers
  end

  def task_params
    params.require(:task).permit(:title, :text).merge(user_id: current_user.id)
  end

  def move_to_index
    set_user
    redirect_to "/" unless user_signed_in? && (current_user.id == @user.id)
  end
end
