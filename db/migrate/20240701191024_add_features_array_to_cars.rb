class AddFeaturesArrayToCars < ActiveRecord::Migration[7.1]
  def change
    add_column :cars, :features_array, :text, array: true, default: []

    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE cars
          SET features_array = string_to_array(features, ',')
        SQL
      end
    end
  end
end
