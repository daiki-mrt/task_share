class RoomsController < ApplicationController
  def show
    # 相手ユーザーを取得
    @user = User.find(params[:id])

    # user_roomから自分が含まれるidを取得
    room_ids = current_user.user_rooms.pluck(:room_id)
    # 取得したuser_roomのうち、自分と相手のペアを探す
    target_user_room = UserRoom.find_by(room_id: room_ids, user_id: @user.id)
    
    if target_user_room.present?
      # 自分と相手のペアがあれば、そこがDMをするroom
      @room = target_user_room.room
    else
      # 無ければ、roomを作成する、そこがDMをするroom
      @room = Room.create
      # user_roomに「自分id - 作成したroom_id」「相手id - 作成したroom_id」を保存する
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    end

    # roomで表示するmessage
    @messages = @room.messages
    # 投稿用にmesssageインスタンス作成
    @message = Message.new
  end
end
