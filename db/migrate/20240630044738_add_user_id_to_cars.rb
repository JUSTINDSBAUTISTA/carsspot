class AddUserIdToCars < ActiveRecord::Migration[7.1]
  def change
    add_column :cars, :user_id, :integer
  end
end
