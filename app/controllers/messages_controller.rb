class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    redirect_to room_path(params[:message][:room_id]) if @message.save
  end

  private

  def message_params
    params.require(:message).permit(:text, :room_id).merge(user_id: current_user.id)
  end
end
