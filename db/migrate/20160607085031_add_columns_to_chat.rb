class AddColumnsToChat < ActiveRecord::Migration
  def change
    add_column :chats, :user_id, :integer
    add_column :chats, :admin_id, :integer
    add_column :chats, :unread_messages, :integer
  end
end
