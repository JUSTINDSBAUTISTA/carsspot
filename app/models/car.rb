class Car < ApplicationRecord
  belongs_to :user
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites
  has_many :rentals, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :status, inclusion: { in: %w[pending approved rejected] }
  validates :car_type, :image, :car_name, presence: true
  validates :features, :transmission, :fuel_type, :car_make, :plate_number, :mileage, :number_of_doors, :number_of_seat, presence: false
  validates :number_of_doors, presence: true

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  after_initialize :set_default_status, if: :new_record?
  after_create :notify_admins

  scope :pending_approval, -> { where(status: 'pending') }
  scope :filter_by_instant_booking, -> (instant_booking) { where(instant_booking: instant_booking) }
  scope :filter_by_number_of_places, -> (number_of_places) { where('number_of_seat >= ?', number_of_places) }
  scope :filter_by_recent, -> (recent_cars) { where('created_at >= ?', 5.years.ago) if recent_cars == '1' }
  scope :filter_by_equipment, -> (equipment) { where('features @> ARRAY[?]::text[]', equipment.map(&:to_s)) }
  scope :filter_by_gearbox, -> (gearbox) { where(transmission: gearbox) }
  scope :filter_by_engine, -> (engine) { where(fuel_type: engine) }
  scope :filter_by_brand, -> (brand) { where(car_make: brand) }

  def image_url
    if image.present? && image.match?(URI::regexp(%w[http https]))
      image
    else
      ActionController::Base.helpers.asset_path('fallback_image.png')
    end
  rescue
    ActionController::Base.helpers.asset_path('fallback_image.png')
  end

  private

  def set_default_status
    self.status ||= 'pending'
  end

  def check_pending_status
    if status == 'pending' && !user.admin?
      Rails.logger.debug "Attempted to delete a pending car: #{self.inspect}"
      errors.add(:base, "Cannot delete a car that is pending approval")
      throw(:abort)
    else
      Rails.logger.debug "Car can be deleted: #{self.inspect}"
    end
  end

  def notify_admins
    admins = User.where(admin: true)
    admins.each do |admin|
      Notification.create(
        recipient: admin,
        actor: self.user,
        notifiable: self,
        message: "A new car (#{self.car_name}) has been submitted for approval."
      )
    end
  end
end
