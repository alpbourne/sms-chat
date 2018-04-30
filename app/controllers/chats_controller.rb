class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chats = current_user.chats.includes(:friend).all
  end
end
