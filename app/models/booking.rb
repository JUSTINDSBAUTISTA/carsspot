class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :car

  validates :start_date, :end_date, :driving_license, :id_proof, presence: true
end
