class AddDetailsToRentals < ActiveRecord::Migration[7.1]
  def change
    add_column :rentals, :driving_license, :string
    add_column :rentals, :id_proof, :string
  end
end
