class MessagesController < ApplicationController
    
  def create
    if Entry.where(user_id: current_user.id, room_id: params[:message][:room_id]).present?
      @message = Message.new(message_params)
      if @message.save
        redirect_to request.referer
      else
        redirect_to request.referer, notice: "You have failed to send message."
      end
    else
      redirect_to request.referer, notice: "Error."
    end
  end
  
  private
  def message_params
    params.require(:message).permit(:user_id, :room_id, :content).merge(user_id: current_user.id)
  end
  
end
