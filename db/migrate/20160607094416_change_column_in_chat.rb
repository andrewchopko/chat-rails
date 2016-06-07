class ChangeColumnInChat < ActiveRecord::Migration
  def change
    change_column :chats, :user_id, :string
  end
end
