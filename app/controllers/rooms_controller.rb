class RoomsController < ApplicationController
  def show
    @room = Room.find(params[:id])
    # DM相手のデータを取得
    current_user_room = @room.user_rooms.where.not(user_id: current_user.id).take
    user_id = current_user_room.user_id
    @user = User.find(user_id)

    @messages = @room.messages.includes(:user)
    @message = Message.new
  end

  def create
    @room = Room.create
    # user_roomに「自分id - 作成したroom_id」「相手id - 作成したroom_id」を保存する
    UserRoom.create(user_id: current_user.id, room_id: @room.id)
    UserRoom.create(user_id: params[:format], room_id: @room.id)
    redirect_to room_path(@room.id)
  end
end
