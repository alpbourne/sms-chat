class Friend < ActiveRecord::Base
  belongs_to :user
  has_one :chat
  after_create :create_chat!

  def create_chat!
    Chat.find_or_create_by(friend: self, user: self.user)
  end
end
