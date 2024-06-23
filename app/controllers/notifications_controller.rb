class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = policy_scope(Notification).recent
    authorize @notifications
  end

  def mark_as_read
    @notification = Notification.find(params[:id])
    authorize @notification
    @notification.mark_as_read!
    redirect_to notifications_path, notice: 'Notification marked as read.'
  end
end
