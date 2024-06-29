class Admin::CarsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
  before_action :set_car, only: [:approve, :reject]

  def index
    @cars = Car.where(status: 'pending').includes(:user)
  end

  def approve
    if @car.update(status: 'approved')
      notification = create_status_notification(@car, 'approved')
      NotificationBroadcastJob.perform_later(notification)
      redirect_to admin_cars_path, notice: 'Car approved successfully.'
    else
      redirect_to admin_cars_path, alert: 'Failed to approve the car.'
    end
  end

  def reject
    if @car.update(status: 'rejected')
      notification = create_status_notification(@car, 'rejected')
      NotificationBroadcastJob.perform_later(notification)
      redirect_to admin_cars_path, notice: 'Car rejected successfully.'
    else
      redirect_to admin_cars_path, alert: 'Failed to reject the car.'
    end
  end

  private

  def set_car
    @car = Car.find(params[:id])
  end

  def authorize_admin!
    redirect_to root_path, alert: 'Access denied!' unless current_user.admin?
  end

  def create_status_notification(car, status)
    Notification.create!(
      recipient: car.user,
      actor: current_user,
      notifiable: car,
      message: "Your car (#{car.car_name}) has been #{status}."
    )
  end
end
