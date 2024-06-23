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
    rental = @notification.notifiable
    if rental.update(status: 'approved')
      @notification.update(read: true)
      create_status_notification(rental, 'approved')
      redirect_to notifications_path, notice: 'Rental request approved.'
    else
      redirect_to notifications_path, alert: 'Unable to approve rental request.'
    end
  end

  def reject
    rental = @notification.notifiable
    if rental.update(status: 'rejected')
      @notification.update(read: true)
      create_status_notification(rental, 'rejected')
      redirect_to notifications_path, notice: 'Rental request rejected.'
    else
      redirect_to notifications_path, alert: 'Unable to reject rental request.'
    end
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
    authorize @notification
  end

  def create_status_notification(rental, status)
    Notification.create!(
      recipient: rental.user,
      actor: rental.car.user,
      notifiable: rental,
      message: "Your rental request for #{rental.car.car_name} has been #{status}.",
      read: false
    )
  end
end
