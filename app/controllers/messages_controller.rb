class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    binding.pry
    if @message.save
      redirect_to room_path(params[:room_id])
    else
      redirect_to room_path(params[:room_id])
    end
  end

  private
  def message_params
    params.require(:message).permit(:text).merge(room_id: params[:room_id], user_id: current_user.id)
  end
end
