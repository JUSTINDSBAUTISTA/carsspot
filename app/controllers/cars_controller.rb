class CarsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_car, only: [:show, :edit, :update, :destroy]

  def index
    @cars = policy_scope(Car).where(status: 'approved')
    @markers = @cars.map do |car|
      {
        id: car.id,
        lat: car.latitude,
        lng: car.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { car: car })
      }
    end
  end

  def show
    authorize @car
  end

  def new
    @car = Car.new
    authorize @car
  end

  def create
    @car = Car.new(car_params)
    @car.user = current_user
    @car.status = 'pending'  # Set status to pending by default
    authorize @car
    if @car.save
      redirect_to @car, notice: 'Car was successfully created and is pending approval.'
    else
      render :new
    end
  end

  def edit
    authorize @car
  end

  def update
    authorize @car
    if @car.update(car_params)
      redirect_to @car, notice: 'Car was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @car
    if @car.destroy
      redirect_to cars_url, notice: 'Car was successfully destroyed.'
    else
      redirect_to @car, alert: 'Car cannot be deleted.'
    end
  end

  def my_cars
    @cars = current_user.cars
    authorize @cars
  end

  def pending_approval
    @cars = policy_scope(Car).where(status: 'pending')
    authorize @cars, :pending_approval?
  end

  private

  def set_car
    @car = Car.find_by(id: params[:id])
    unless @car
      redirect_to cars_url, alert: "Car not found."
    end
  end

  def car_params
    params.require(:car).permit(:car_name, :features, :transmission, :fuel_type, :car_make, :image, :price_per_day, :rating, :number_of_seat, :status, :address)
  end
end
