class AddStatusToCars < ActiveRecord::Migration[7.1]
  def change
    add_column :cars, :status, :string
  end
end
