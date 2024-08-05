class AddAvailabilityTimesToCars < ActiveRecord::Migration[7.1]
  def change
    add_column :cars, :availability_start_time, :time
    add_column :cars, :availability_end_time, :time
  end
end
