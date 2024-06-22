class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :car, null: false, foreign_key: true
      t.references :actor, null: false, foreign_key: { to_table: :users }
      t.string :action
      t.boolean :read, default: false
      t.references :notifiable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
