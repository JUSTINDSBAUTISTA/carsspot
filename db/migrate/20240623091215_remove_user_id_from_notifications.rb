class RemoveUserIdFromNotifications < ActiveRecord::Migration[7.1]
  def change
    remove_column :notifications, :user_id, :bigint
  end
end
