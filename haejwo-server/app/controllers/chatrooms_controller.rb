class ChatroomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chatrooms = Chatroom.where('request_user_id = :user_id OR perform_user_id = :user_id', user_id: current_user.id)
  end

  # 채팅방 상세보기
  def show
    @chatroom = Chatroom.find params[:id]
    @message = Message.new
    @messages = @chatroom.messages
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
