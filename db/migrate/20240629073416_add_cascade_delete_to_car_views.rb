class AddCascadeDeleteToCarViews < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :car_views, :cars
    add_foreign_key :car_views, :cars, on_delete: :cascade
  end
end
