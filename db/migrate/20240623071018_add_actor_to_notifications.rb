class AddActorToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :actor_id, :bigint unless column_exists?(:notifications, :actor_id)
  end
end
