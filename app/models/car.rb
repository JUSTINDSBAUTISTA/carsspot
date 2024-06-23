class Car < ApplicationRecord
  belongs_to :user
  has_many :notifications, dependent: :destroy
  has_many :favorites
  has_many :users, through: :favorites
  has_many :rentals
  has_many :reviews, dependent: :destroy

  validates :status, inclusion: { in: %w[pending approved rejected] }

  after_initialize :set_default_status, if: :new_record?

  scope :pending_approval, -> { where(status: 'pending') }

  before_destroy :check_pending_status, prepend: true

  private

  def set_default_status
    self.status ||= 'pending'
  end

  def check_pending_status
    if status == 'pending'
      errors.add(:base, "Cannot delete a car that is pending approval")
      throw(:abort)
    end
  end
end
