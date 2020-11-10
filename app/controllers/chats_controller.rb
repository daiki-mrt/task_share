class ChatsController < ApplicationController
  before_action :set_community, only: [:index, :create, :destroy]
  before_action :set_chats, only: [:index, :create, :destroy]
  before_action :move_to_index
  
  def index
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
