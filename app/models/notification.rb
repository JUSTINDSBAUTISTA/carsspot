class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :actor, class_name: 'User', foreign_key: 'actor_id'
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc).limit(5) }

  def mark_as_read!
    update(read: true)
  end
end
