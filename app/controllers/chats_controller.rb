class ChatsController < ApplicationController
  before_action :set_community, only: [:index, :create]
  before_action :set_chats, only: [:index, :create]
  
  def index
    set_community
    set_chats
    @chat = Chat.new
  end

  def create
    @chat = Chat.new(chat_params)
    if @chat.save
      redirect_to community_chats_path(@community)
    else      
      render :index
    end
  end

  private
  def set_community
    @community = Community.find(params[:community_id])
  end

  def set_chats
    @chats = Chat.includes(:user)
  end

  def chat_params
    params.require(:chat).permit(:text).merge(user_id: current_user.id, community_id: params[:community_id])
  end
end
