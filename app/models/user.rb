class User < ApplicationRecord
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id'
  has_many :received_messages, class_name: 'Message', foreign_key: 'recipient_id'
  has_many :favorites
  has_many :cars, through: :favorites
  has_many :rentals
  has_many :notifications_as_recipient, class_name: 'Notification', foreign_key: 'recipient_id', dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def admin?
    self.admin
  end
end
