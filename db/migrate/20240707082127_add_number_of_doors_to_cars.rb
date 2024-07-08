class AddNumberOfDoorsToCars < ActiveRecord::Migration[7.1]
  def change
    add_column :cars, :number_of_doors, :integer
  end
end
