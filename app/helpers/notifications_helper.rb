# app/helpers/notifications_helper.rb
module NotificationsHelper
  def render_notification_details(notification)
    if notification.notifiable_type == 'Rental'
      rental = notification.notifiable
      user = rental.user
      car = rental.car

      content_tag(:div, class: 'notification-details') do
        concat content_tag(:p, content_tag(:strong, 'Message: ') + notification.message)
        concat render_rental_details(rental, user, car, notification)
      end
    else
      content_tag(:p, notification.message)
    end
  end

  def render_rental_details(rental, user, car, notification)
    renter_info = content_tag(:div, class: 'renter-info') do
      concat content_tag(:p, content_tag(:strong, 'Renter ID: ') + user.id.to_s)
      concat content_tag(:p, content_tag(:strong, 'Renter: ') + user.name)
      concat content_tag(:p, content_tag(:strong, 'Email: ') + user.email)
      concat content_tag(:p, content_tag(:strong, 'Phone: ') + user.phone_number)
    end

    car_info = content_tag(:div, class: 'car-info') do
      concat content_tag(:p, content_tag(:strong, 'Car: ') + "#{car.car_name} (#{car.car_make})")
      concat image_tag(car.image, alt: "#{car.car_name} image", style: 'width: 200px; height: auto;')
      concat content_tag(:p, content_tag(:strong, 'Rental Start Date: ') + rental.start_date.strftime("%Y-%m-%d %H:%M"))
      concat content_tag(:p, content_tag(:strong, 'Rental End Date: ') + rental.end_date.strftime("%Y-%m-%d %H:%M"))
      concat content_tag(:p, content_tag(:strong, 'Cost: ') + "$#{car.price_per_day * (rental.end_date - rental.start_date).to_i}")
    end

    details = renter_info + car_info

    details + content_tag(:p, content_tag(:strong, 'Request Date: ') + rental.created_at.strftime("%Y-%m-%d %H:%M")) +
      if current_user == notification.recipient && rental.status == 'pending' && car.user == current_user
        link_to('Approve', approve_notification_path(notification), method: :patch, data: { turbo_method: :patch }) +
        ' ' +
        link_to('Reject', reject_notification_path(notification), method: :patch, data: { turbo_method: :patch })
      else
        ''.html_safe
      end
  end
end
