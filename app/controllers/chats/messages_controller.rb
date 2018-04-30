class Chats::MessagesController < ApplicationController
  before_action :authenticate_user!, except: [:reply]
  before_action :set_chat, except: [:repy]
  skip_before_action :verify_authenticity_token, only: [:reply]

  def index
    @messages = @chat.messages.order("create_at ASC")
    @message = @chat.messages.build
  end

  def create
    @message = @chat.messages.build(message_params)
    @message.update(to: @chat.friend.phone, status: 'pending', direction: 'outbound-api')
    if @message.save
      SendSmsJob.perform_later(@message)
      redirect_to chat_messages_path(@chat), notice: 'Message sent'
    else
      redirect_to chat_messages_path(@chat), alert: 'Message failed'
    end
  end

  def reply
    from = params[:From].gsub(/^\+\d/, '')
    body = params[:Body]
    status = params[:SmsStatus]
    direction = 'inbound'
    message_sid = params[:MessageSid]
    friend = Friend.where("phone like ?", "%#{from}%").first
    @chat = Chat.where(friend: friend).first
    @chat.messages.build(body: body, direction: direction, status: status, from: from, message_sid: message_sid).save
    head :ok, content_type: "text/html"
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:chat_id])
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
