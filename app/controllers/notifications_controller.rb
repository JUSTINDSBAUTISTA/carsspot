class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [:show, :approve, :reject]

  def index
    if current_user.admin?
      @cars = policy_scope(Car).where(status: 'pending')
      render 'admin/cars/index'
    else
      @notifications = policy_scope(Notification).order(created_at: :desc)
    end
  end

  def show
    if @notification
      authorize @notification
      @notification.update(read: true)
      redirect_to @notification.url
    else
      Rails.logger.error "Notification not found: ID #{params[:id]}"
      redirect_to notifications_path, alert: 'Notification not found.'
    end
  end

  def approve
    if @notification
      authorize @notification
      notifiable = @notification.notifiable
      if notifiable.is_a?(Car)
        if notifiable.update(status: 'approved')
          @notification.update(read: true)
          create_status_notification(notifiable, 'approved')
          redirect_to notifications_path, notice: 'Car was successfully approved.'
        else
          Rails.logger.error "Failed to approve car: #{notifiable.errors.full_messages.join(', ')}"
          redirect_to notifications_path, alert: 'Unable to approve car.'
        end
      elsif notifiable.is_a?(Rental)
        if notifiable.update(status: 'approved')
          @notification.update(read: true)
          create_status_notification(notifiable, 'approved')
          redirect_to notifications_path, notice: 'Rental was successfully approved.'
        else
          Rails.logger.error "Failed to approve rental: #{notifiable.errors.full_messages.join(', ')}"
          redirect_to notifications_path, alert: 'Unable to approve rental.'
        end
      else
        Rails.logger.error "Notifiable is neither a Car nor a Rental: #{notifiable.class.name}"
        redirect_to notifications_path, alert: 'Unable to approve item.'
      end
    else
      Rails.logger.error "Notification not found: ID #{params[:id]}"
      redirect_to notifications_path, alert: 'Notification not found.'
    end
  end

  def reject
    if @notification
      authorize @notification
      notifiable = @notification.notifiable
      if notifiable.is_a?(Car)
        if notifiable.update(status: 'rejected')
          @notification.update(read: true)
          create_status_notification(notifiable, 'rejected')
          redirect_to notifications_path, notice: 'Car was successfully rejected.'
        else
          Rails.logger.error "Failed to reject car: #{notifiable.errors.full_messages.join(', ')}"
          redirect_to notifications_path, alert: 'Unable to reject car.'
        end
      elsif notifiable.is_a?(Rental)
        if notifiable.update(status: 'rejected')
          @notification.update(read: true)
          create_status_notification(notifiable, 'rejected')
          redirect_to notifications_path, notice: 'Rental was successfully rejected.'
        else
          Rails.logger.error "Failed to reject rental: #{notifiable.errors.full_messages.join(', ')}"
          redirect_to notifications_path, alert: 'Unable to reject rental.'
        end
      else
        Rails.logger.error "Notifiable is neither a Car nor a Rental: #{notifiable.class.name}"
        redirect_to notifications_path, alert: 'Unable to reject item.'
      end
    else
      Rails.logger.error "Notification not found: ID #{params[:id]}"
      redirect_to notifications_path, alert: 'Notification not found.'
    end
  end

  private

  def set_notification
    @notification = Notification.find_by(id: params[:id])
    unless @notification
      Rails.logger.warn "Notification with ID #{params[:id]} not found"
      redirect_to notifications_path, alert: 'Notification not found.'
    end
  end

  def create_status_notification(notifiable, status)
    Notification.create!(
      recipient: notifiable.user,
      actor: current_user,
      notifiable: notifiable,
      message: "Your #{notifiable.class.name.downcase} (#{notifiable.try(:car_name) || notifiable.try(:name)}) has been #{status}."
    )
  end
end
