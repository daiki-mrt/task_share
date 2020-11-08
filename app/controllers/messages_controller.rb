class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    if @message.save
      redirect_to room_path(params[:message][:room_id])
    else
      redirect_to room_path(params[:message][:room_id])
    end
  end

  private
  def message_params
    params.require(:message).permit(:text, :room_id).merge(user_id: current_user.id)
  end
end
