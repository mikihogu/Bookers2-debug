class RoomsController < ApplicationController

  def create
    @room = Room.create
    @entry1 = Entry.create(room_id: @room.id, user_id: current_user.id)
    @entry2 = Entry.create(entry_room_params)
    redirect_to room_path(@room.id)
  end

  def show
    @room = Room.find(params[:id])
    @user = @room.users
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @entries = @room.entries  #詳細ページで表示するため、entriesテーブルのuser_idを取得
    else
      redirect_to room_path(@roomId)
    end
  end

  private

  def entry_room_params
    params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id)
  end

end
