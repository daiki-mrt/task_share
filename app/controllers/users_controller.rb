class UsersController < ApplicationController
  before_action :set_user, only: [:show, :follows, :followers]

  def index
    @search_params = user_search_params
    # @users = User.search(@search_params).includes(:profile)
    @users = User.search(@search_params).includes(profile: { image_attachment: :blob })
  end

  def show
    @tasks = @user.tasks.not_completed.order("created_at DESC")
    # @tasks = Task.user_is(@user.id).not_completed.order("created_at DESC")
    @following_users = @user.followings
    @follower_users = @user.followers
    
    # タスク投稿フォーム用
    @task = Task.new

    # DM用するボタンのためのデータ取得
    # user_roomから自分が含まれるidを取得
    room_ids = current_user.user_rooms.pluck(:room_id)
    # 取得したuser_roomのうち、自分と相手のペアを探す
    @target_user_room = UserRoom.find_by(room_id: room_ids, user_id: @user.id)
    # 特定したuser_roomからroom_idを取得する
    @room = @target_user_room.room if @target_user_room.present?
  end

  # フォロー数
  def follows
    @following_users = @user.followings.includes(profile: { image_attachment: :blob })
  end

  # フォロワー数
  def followers
    @follower_users = @user.followers.includes(profile: { image_attachment: :blob })
  end

  private

  def set_user
    @user = User.find(params[:id])
    @profile = @user.profile
  end

  def user_search_params
    params.fetch(:search, {}).permit(:occupation_id, :text)
  end
end
