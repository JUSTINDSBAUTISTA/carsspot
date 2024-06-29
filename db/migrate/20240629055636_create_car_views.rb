class CreateCarViews < ActiveRecord::Migration[7.1]
  def change
    create_table :car_views do |t|
      t.references :user, null: false, foreign_key: true
      t.references :car, null: false, foreign_key: true

      t.timestamps
    end
  end
end
