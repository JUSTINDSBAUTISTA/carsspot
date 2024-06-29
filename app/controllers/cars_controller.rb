class CarsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :search]
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
    CarView.find_or_create_by(user: current_user, car: @car) if user_signed_in?
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

  def search
    authorize Car
    if params[:location].present? && !params[:location].downcase.include?("canada")
      redirect_to root_path, alert: "We don't operate in this country yet."
      return
    end

    @cars = Car.where(status: 'approved', country: "Canada")
    if params[:location].present?
      @cars = @cars.where("address ILIKE ?", "%#{params[:location]}%")
    end
    @cars = @cars.where("availability_start_date <= ?", params[:pickup_date]) if params[:pickup_date].present?
    @cars = @cars.where("availability_end_date >= ?", params[:return_date]) if params[:return_date].present?

    if params[:location].blank? && params[:pickup_date].blank? && params[:return_date].blank?
      @cars = Car.where(country: "Canada")
    end

    # Debugging statements
    puts "Location: #{params[:location]}"
    puts "Pickup Date: #{params[:pickup_date]}"
    puts "Return Date: #{params[:return_date]}"
    puts "Number of Cars Found: #{@cars.count}"
    puts "SQL Query: #{@cars.to_sql}"

    @markers = @cars.map do |car|
      {
        id: car.id,
        lat: car.latitude,
        lng: car.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { car: car })
      }
    end
    render :index
  end

  private

  def set_car
    @car = Car.find_by(id: params[:id])
    unless @car
      redirect_to cars_url, alert: "Car not found."
    end
  end

  def car_params
    params.require(:car).permit(:car_name, :features, :transmission, :fuel_type, :car_make, :image, :price_per_day, :rating, :number_of_seat, :status, :address, :country, :min_rental_duration, :min_advance_notice, :max_rental_duration, :availability_start_date, :availability_end_date, :owner_rules)
  end
end
