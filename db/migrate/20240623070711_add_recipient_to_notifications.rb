class AddRecipientToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :recipient_id, :integer unless column_exists?(:notifications, :recipient_id)
  end
end
