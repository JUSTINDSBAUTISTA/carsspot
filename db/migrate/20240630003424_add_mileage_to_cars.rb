class AddMileageToCars < ActiveRecord::Migration[7.1]
  def change
    add_column :cars, :mileage, :integer
  end
end
