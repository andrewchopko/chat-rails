class Chat < ActiveRecord::Base
  has_many :messages
  has_many :user
end
