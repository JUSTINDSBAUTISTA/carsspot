class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [:show, :mark_as_read, :approve, :reject]

  def index
    @notifications = policy_scope(Notification).order(created_at: :desc)
  end

  def show
    @notification.mark_as_read!
    render :show
  end

  def mark_as_read
    @notification.update(read: true)
    redirect_to notifications_path, notice: 'Notification marked as read.'
  end

  def approve
    authorize @notification, :approve?
    car = @notification.notifiable
    if car.update(status: 'approved')
      @notification.update(read: true)
      create_status_notification(car, 'approved')
      redirect_to notifications_path, notice: 'Car was successfully approved.'
    else
      redirect_to notifications_path, alert: 'Unable to approve car.'
    end
  end

  def reject
    authorize @notification, :reject?
    car = @notification.notifiable
    if car.update(status: 'rejected')
      @notification.update(read: true)
      create_status_notification(car, 'rejected')
      redirect_to notifications_path, notice: 'Car was successfully rejected.'
    else
      redirect_to notifications_path, alert: 'Unable to reject car.'
    end
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
    authorize @notification
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
