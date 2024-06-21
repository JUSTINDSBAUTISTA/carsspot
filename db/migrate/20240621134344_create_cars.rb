class CreateCars < ActiveRecord::Migration[7.1]
  def change
    create_table :cars do |t|
      t.string :car_name
      t.string :features
      t.string :transmission
      t.string :fuel_type
      t.string :car_make
      t.string :image
      t.integer :price_per_day
      t.integer :rating
      t.integer :number_of_seat

      t.timestamps
    end
  end
end
