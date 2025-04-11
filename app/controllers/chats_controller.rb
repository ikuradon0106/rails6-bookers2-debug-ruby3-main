class ChatsController < ApplicationController
  # showアクションにおいて、関連のないユーザーをブロックする
  before_action :block_non_related_user, only: [:show]

  # チャットルームの表示
  def show
    # チャット相手のユーザーを取得
    @user = User.find(params[:id])

    # 現在のユーザーが参加しているチャットルームの一覧を取得
    rooms = current_user.user_rooms.pluck(:room_id)

    # 相手ユーザーとの共有チャットルームが存在するか確認
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)
  
    unless user_rooms.nil?
      @room = user_rooms.room
    else
      @room = Room.new
      @room.save
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    end
  
    @chats = @room.chats
    @chat = Chat.new(room_id: @room.id)
  end

end
