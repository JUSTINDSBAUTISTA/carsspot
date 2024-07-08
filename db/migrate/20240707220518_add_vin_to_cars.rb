class AddVinToCars < ActiveRecord::Migration[7.1]
  def change
    add_column :cars, :vin, :string
  end
end
