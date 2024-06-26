class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'

  validates :body, presence: true

  after_initialize :set_default_read, if: :new_record?

  def set_default_read
    self.read ||= false
  end
end
