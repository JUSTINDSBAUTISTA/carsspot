class RentalsController < ApplicationController
  before_action :set_rental, only: [:show, :edit, :update, :destroy]
  before_action :set_car, only: [:new, :create]
  after_action :verify_authorized, except: [:index]
  after_action :verify_policy_scoped, only: :index

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
    @rental = Rental.find(params[:id])
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
