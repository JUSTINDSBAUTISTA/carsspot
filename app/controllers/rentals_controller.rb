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

    if @rental.save
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
    authorize @rental
    if @rental.update(status: 'approved')
      Notification.create(
        recipient: @rental.car.user,
        actor: current_user,
        notifiable: @rental,
        message: "#{current_user.name} approved the rental request for #{@rental.car.car_name}",
        read: false
      )
      redirect_to rentals_path, notice: 'Rental approved successfully.'
    else
      redirect_to rentals_path, alert: 'Failed to approve the rental.'
    end
  end

  def reject
    authorize @rental
    if @rental.update(status: 'rejected')
      Notification.create(
        recipient: @rental.car.user,
        actor: current_user,
        notifiable: @rental,
        message: "#{current_user.name} rejected the rental request for #{@rental.car.car_name}",
        read: false
      )
      redirect_to rentals_path, notice: 'Rental rejected successfully.'
    else
      redirect_to rentals_path, alert: 'Failed to reject the rental.'
    end
  end

  private

  def set_rental
    @rental = Rental.find(params[:id])
  end

  def set_car
    @car = Car.find(params[:car_id])
  end

  def rental_params
    params.require(:rental).permit(:start_date, :end_date, :driving_license, :id_proof, :car_id)
  end
end
