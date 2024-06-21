class CreateRentals < ActiveRecord::Migration[7.1]
  def change
    create_table :rentals do |t|

      t.timestamps
    end
  end
end
