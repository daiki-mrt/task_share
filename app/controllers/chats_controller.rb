class ChatsController < ApplicationController
  before_action :set_community, only: [:index, :create, :destroy]
  before_action :set_chats, only: [:index, :create, :destroy]
  before_action :move_to_index, except: :index

  def index
    @chat = Chat.new
    @joined_users = @community.joined_users
    # タスク総数を取得 → ビューで完了未完了を分岐
    @tasks = Task.user_is(@joined_users.pluck(:id)).order("created_at DESC")
    @questions = Question.where(community_id: @community.id)
  end

  def create
    @chat = Chat.new(chat_params)
    if @chat.save
      redirect_to community_chats_path(@community)
    else
      @joined_users = @community.joined_users
      # タスク総数を取得 → ビューで完了未完了を分岐
      @tasks = Task.user_is(@joined_users.pluck(:id)).order("created_at DESC")
      @questions = Question.where(community_id: @community.id)
      render :index
    end
  end

  def destroy
    @chat = Chat.find(params[:id])
    @chat.destroy
    redirect_to community_chats_path(@community)
  end

  private

  def set_community
    @community = Community.find(params[:community_id])
  end

  def set_chats
    @chats = @community.chats.includes(:user)
  end

  def chat_params
    params.require(:chat).permit(:text).merge(user_id: current_user.id, community_id: params[:community_id])
  end

  def move_to_index
    set_community
    if !current_user.already_joined?(@community)
      redirect_to community_path(@community)
    end
  end
end
