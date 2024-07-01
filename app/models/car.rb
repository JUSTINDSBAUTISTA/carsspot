class Car < ApplicationRecord
  belongs_to :user
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites
  has_many :rentals, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :status, inclusion: { in: %w[pending approved rejected] }
  validates :car_type, presence: true # Add this validation

  after_initialize :set_default_status, if: :new_record?
  after_create :notify_admins

  scope :pending_approval, -> { where(status: 'pending') }

  before_destroy :check_pending_status, prepend: true

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
