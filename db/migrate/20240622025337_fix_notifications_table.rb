class FixNotificationsTable < ActiveRecord::Migration[7.1]
  def change
    change_table :notifications do |t|
      t.remove :user if column_exists?(:notifications, :user)
      t.references :user, null: false, foreign_key: true unless column_exists?(:notifications, :user_id)
      t.boolean :read, default: false unless column_exists?(:notifications, :read)
    end
  end
end
