class Car < ApplicationRecord
  belongs_to :user
  has_many :notifications, dependent: :destroy
  has_many :favorites
  has_many :users, through: :favorites
  has_many :rentals
  has_many :reviews, dependent: :destroy

  validates :status, inclusion: { in: %w[pending approved rejected] }

  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= 'pending'
  end
end
