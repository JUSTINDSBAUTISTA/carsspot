class AddInstantBookingToCars < ActiveRecord::Migration[7.1]
  def change
    add_column :cars, :instant_booking, :boolean
  end
end
