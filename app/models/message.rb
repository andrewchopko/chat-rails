class Message < ActiveRecord::Base
  belongs_to :chats
  belongs_to :user

  validates :content, presence: true
end
