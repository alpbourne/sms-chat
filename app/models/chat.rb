class Chat < ActiveRecord::Base
  belongs_to :friend
  belongs_to :user
  has_many :messages
end
