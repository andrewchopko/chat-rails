class Chat < ActiveRecord::Base
  has_many :messages, dependent: :destroy
  has_many :user

  validates :name, presence: true
  validates :user_id, presence: true
end
