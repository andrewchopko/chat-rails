class Message < ActiveRecord::Base
  belongs_to :chats
  belongs_to :user
end
