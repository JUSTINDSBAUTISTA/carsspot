class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.integer :recipient_id, null: false
      t.integer :actor_id, null: false
      t.references :notifiable, polymorphic: true, null: false
      t.string :message
      t.boolean :read, default: false

      t.timestamps
    end

    add_foreign_key :notifications, :users, column: :recipient_id
    add_foreign_key :notifications, :users, column: :actor_id
  end
end
