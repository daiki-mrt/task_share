class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    if @message.save
      redirect_to room_path(params[:message][:room_id])
    else
      # "rooms/show"のデータ取得
      @room = Room.find(params[:message][:room_id])
      current_user_room = @room.user_rooms.where.not(user_id: current_user.id).take
      user_id = current_user_room.user_id
      @user = User.find(user_id)
      @messages = @room.messages.includes(:user)
      @message = Message.new

      render "rooms/show"
    end
  end

  private

  def message_params
    params.require(:message).permit(:text, :room_id).merge(user_id: current_user.id)
  end
end
