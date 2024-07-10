class RentalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_rental, only: [:show, :edit, :update, :destroy, :approve, :reject]
  before_action :set_car, only: [:new, :create]

  def index
    @rentals = policy_scope(Rental)
  end

  def show
    authorize @rental
  end

  def new
    @rental = Rental.new
    authorize @rental
  end

  def create
    @rental = Rental.new(rental_params)
    @rental.user = current_user
    @rental.car = @car
    authorize @rental

    if @car.user == current_user
      redirect_to @car, alert: 'You cannot rent your own car.'
    elsif @rental.save
      Rails.logger.debug "Creating notification for rental request by #{current_user.name} for car #{@car.car_name}"
      Notification.create(
        recipient: @car.user,
        actor: current_user,
        notifiable: @rental,
        message: "#{current_user.name} requested to rent #{@rental.car.car_name}",
        read: false
      )
      redirect_to @rental, notice: 'Rental request was successfully created.'
    else
      render :new
    end
  end

  def edit
    authorize @rental
  end

  def update
    authorize @rental
    if @rental.update(rental_params)
      redirect_to @rental, notice: 'Rental was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @rental
    @rental.destroy
    redirect_to rentals_url, notice: 'Rental was successfully destroyed.'
  end

  def approve
    authorize @rental, :approve?
    if @rental.status == 'pending'
      if @rental.update(status: 'approved')
        Notification.create(
          recipient: @rental.user,
          actor: current_user,
          notifiable: @rental,
          message: "Your rental request for #{@rental.car.car_name} has been approved.",
          read: false
        )
        redirect_to notifications_path, notice: 'Rental approved successfully.'
      else
        redirect_to notifications_path, alert: 'Failed to approve the rental.'
      end
    else
      redirect_to notifications_path, alert: 'Rental has already been processed.'
    end
  end

  def reject
    authorize @rental, :reject?
    if @rental.status == 'pending'
      if @rental.update(status: 'rejected')
        Notification.create(
          recipient: @rental.user,
          actor: current_user,
          notifiable: @rental,
          message: "Your rental request for #{@rental.car.car_name} has been rejected.",
          read: false
        )
        redirect_to notifications_path, notice: 'Rental rejected successfully.'
      else
        redirect_to notifications_path, alert: 'Failed to reject the rental.'
      end
    else
      redirect_to notifications_path, alert: 'Rental has already been processed.'
    end
  end

  private

  def set_rental
    @rental = Rental.find(params[:id])
  end

  def set_car
    Rails.logger.debug "Params: #{params.inspect}"
    car_id = params[:car_id] || params.dig(:rental, :car_id)
    if car_id.present?
      @car = Car.find(car_id)
    else
      raise ActiveRecord::RecordNotFound, "Car ID is missing"
    end
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "Car not found: #{e.message}"
    redirect_to cars_path, alert: "Car not found."
  end

  def rental_params
    params.require(:rental).permit(:start_date, :end_date, :driving_license, :id_proof, :car_id, :driving_license_front_image, :driving_license_back_image)
  end


end
