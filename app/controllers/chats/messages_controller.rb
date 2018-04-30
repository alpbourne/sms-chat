class Chats::MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat, except: [:repy]

  def index
    @messages = @chat.messages.order("create_at ASC")
    @message = @chat.messages.build
  end

  def create
    @message = @chat.messages.build(message_params)
    @message.update(to: @chat.friend.phone, status: 'pending', direction: 'outbound-api')
    if @message.save
      redirect_to chat_messages_path(@chat), notice: 'Message sent'
    else
      redirect_to chat_messages_path(@chat), alert: 'Message failed'
    end
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:chat_id])
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
