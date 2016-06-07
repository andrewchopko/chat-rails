class AddColumnToChat < ActiveRecord::Migration
  def change
    add_column :chats, :unread_messages_admin, :integer
  end
end
