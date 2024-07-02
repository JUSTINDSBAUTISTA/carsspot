class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :actor, class_name: 'User', foreign_key: 'actor_id'
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc).limit(5) }

  def mark_as_read!
    update(read: true)
  end

  def url
    unless notifiable.present?
      Rails.logger.debug "Notifiable object is missing for notification ID: #{id}"
      return Rails.application.routes.url_helpers.root_path
    end

    generated_url = case notifiable
                    when Car
                      Rails.application.routes.url_helpers.car_path(notifiable)
                    when Rental
                      Rails.application.routes.url_helpers.rental_path(notifiable)
                    when Message
                      Rails.application.routes.url_helpers.message_path(notifiable)
                    else
                      Rails.application.routes.url_helpers.root_path
                    end

    Rails.logger.debug "Generated URL for notification ID: #{id}, URL: #{generated_url}"
    generated_url
  end
end
