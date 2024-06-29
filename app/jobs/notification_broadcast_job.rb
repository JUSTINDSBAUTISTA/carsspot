# app/jobs/notification_broadcast_job.rb
class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(notification)
    NotificationChannel.broadcast_to(
      notification.recipient,
      notification: render_notification(notification)
    )
  end

  private

  def render_notification(notification)
    ApplicationController.renderer.render(partial: 'notifications/notification', locals: { notification: notification })
  end
end
