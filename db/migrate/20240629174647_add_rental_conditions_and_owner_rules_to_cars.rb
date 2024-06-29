class AddRentalConditionsAndOwnerRulesToCars < ActiveRecord::Migration[7.1]
  def change
    add_column :cars, :min_rental_duration, :integer
    add_column :cars, :max_rental_duration, :integer
    add_column :cars, :min_advance_notice, :integer
    add_column :cars, :availability_start_date, :date
    add_column :cars, :availability_end_date, :date
    add_column :cars, :owner_rules, :text
  end
end
