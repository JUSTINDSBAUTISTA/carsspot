# app/models/rental.rb
class Rental < ApplicationRecord
  belongs_to :user
  belongs_to :car

  after_create :create_notification
  before_create :set_initial_status

  private

  def set_initial_status
    self.status ||= 'pending'
  end

  def create_notification
    notification = Notification.create!(
      recipient_id: self.car.user_id,
      actor_id: self.user_id,
      notifiable: self,
      message: "#{self.user.name} requested to rent your car #{self.car.car_name}",
      read: false
    )



  def render_notification(notification)
    ApplicationController.render(
      partial: 'notifications/notification',
      locals: { notification: notification }
    )
  end
end
end
