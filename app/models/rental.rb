class Rental < ApplicationRecord
  belongs_to :user
  belongs_to :car

  before_create :set_initial_status

  has_one_attached :driving_license_front_image
  has_one_attached :driving_license_back_image

  private

  def set_initial_status
    self.status ||= 'pending'
  end
end
