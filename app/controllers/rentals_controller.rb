
class RentalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_car, only: [:new, :create]
  before_action :set_rental, only: [:show, :edit, :update, :destroy]

  def index
    @rentals = policy_scope(Rental)
    authorize @rentals
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
        user: @car.user, # Set the user receiving the notification
        recipient: @car.user,
        actor: current_user,
        action: 'requested to rent',
        notifiable: @rental
      )
      CarOwnerMailer.with(rental: @rental).new_rental_request.deliver_later
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

  private

  def set_car
    @car = Car.find(params[:car_id])
  end

  def set_rental
    @rental = Rental.find(params[:id])
  end

  def rental_params
    params.require(:rental).permit(:start_date, :end_date, :driving_license, :id_proof)
  end
end
