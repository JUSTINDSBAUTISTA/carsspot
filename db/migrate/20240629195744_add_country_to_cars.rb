class AddCountryToCars < ActiveRecord::Migration[7.1]
  def change
    add_column :cars, :country, :string
  end
end
