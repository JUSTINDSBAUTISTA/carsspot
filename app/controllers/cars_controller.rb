class CarsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_car, only: [:show, :edit, :update, :destroy, :approve, :reject]

  def index
    @cars = policy_scope(Car)
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
    authorize @car
    if @car.save
      redirect_to @car, notice: 'Car was successfully created.'
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
      redirect_to @car, alert: 'Car cannot be deleted while it is pending approval.'
    end
  end

  def my_cars
    @cars = current_user.cars
    authorize @cars
  end

  def pending_approval
    @cars = policy_scope(Car).pending_approval
    authorize @cars, :pending_approval?
  end

  private

  def set_car
    @car = Car.find(params[:id])
  end

  def car_params
    params.require(:car).permit(:car_name, :features, :transmission, :fuel_type, :car_make, :image, :price_per_day, :rating, :number_of_seat, :status)
  end
end
