class AddDetailsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :birthday, :date
    add_column :users, :phone_number, :string
    add_column :users, :address, :string
    add_column :users, :zip_code, :string
    add_column :users, :town, :string
    add_column :users, :country, :string
    add_column :users, :about_me, :text
  end
end
