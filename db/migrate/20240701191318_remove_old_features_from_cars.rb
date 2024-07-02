class RemoveOldFeaturesFromCars < ActiveRecord::Migration[7.1]
  def change
    remove_column :cars, :features, :string
    rename_column :cars, :features_array, :features
  end
end
