class CarsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :search, :confirm_vin]
  before_action :set_car, only: [:show, :edit, :update, :destroy]
  before_action :set_car_types, only: [:index, :new, :create, :edit, :update, :search]
  after_action :verify_authorized, except: [:index, :show, :search, :confirm_vin]

  def index
    @cars = policy_scope(Car).where(status: 'approved')

    if params[:location].present?
      @cars = @cars.where("address ILIKE ?", "%#{params[:location]}%")
    end

    if params[:pickup_date].present? && params[:return_date].present?
      @cars = @cars.where(
        "(availability_start_date <= ? AND availability_end_date >= ?) OR
         (availability_start_date <= ? AND availability_end_date >= ?) OR
         (availability_start_date >= ? AND availability_end_date <= ?)",
        params[:pickup_date], params[:pickup_date],
        params[:return_date], params[:return_date],
        params[:pickup_date], params[:return_date]
      )

      if params[:pickup_time].present? && params[:return_time].present?
        pickup_time = Time.parse(params[:pickup_time])
        return_time = Time.parse(params[:return_time])

        @cars = @cars.where(
          "(availability_start_time <= ? AND availability_end_time >= ?) OR
           (availability_start_time <= ? AND availability_end_time >= ?) OR
           (availability_start_time >= ? AND availability_end_time <= ?)",
          pickup_time, pickup_time,
          return_time, return_time,
          pickup_time, return_time
        )
      end
    end

    if params[:car_types].present?
      @cars = @cars.where(car_type: params[:car_types].split(','))
    end

    @cars = @cars.filter_by_instant_booking(params[:instant_booking]) if params[:instant_booking].present?
    @cars = @cars.filter_by_number_of_places(params[:number_of_places]) if params[:number_of_places].present?
    @cars = @cars.filter_by_recent(params[:recent_cars]) if params[:recent_cars].present?
    @cars = @cars.filter_by_equipment(params[:equipment]) if params[:equipment].present?
    @cars = @cars.filter_by_gearbox(params[:gearbox]) if params[:gearbox].present?
    @cars = @cars.filter_by_engine(params[:engine]) if params[:engine].present?
    @cars = @cars.filter_by_brand(params[:brand]) if params[:brand].present?

    @markers = @cars.map do |car|
      {
        id: car.id,
        lat: car.latitude,
        lng: car.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { car: car })
      }
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    authorize @car
    @rental = Rental.new
    CarView.find_or_create_by(user: current_user, car: @car) if user_signed_in?

    respond_to do |format|
      format.html { render :show }
      format.js {
        logger.debug "Rendering car details for car ID: #{@car.id}"
        render partial: 'cars/car_details', locals: { car: @car }
      }
    end
  end

  def new
    @car = Car.new
    @step = params[:step] || 'step1'
    authorize @car
  end

  def create
    @car = Car.new(car_params)
    @car.user = current_user
    authorize @car

    if params[:step] == 'step1'
      render :new, locals: { step: 'step2' }
    elsif @car.save
      if @car.image.attached?
        CloudinaryUploadWorker.perform_async(url_for(@car.image))
      end
      redirect_to @car, notice: 'Car was successfully created and is pending approval.'
    else
      render :new, locals: { step: 'step1' }, status: :unprocessable_entity
    end
  end

  def edit
    authorize @car
  end

  def update
    authorize @car

    Rails.logger.debug "Car Params: #{car_params.inspect}"

    if @car.update(car_params)
      redirect_to @car, notice: 'Car was successfully updated.'
    else
      Rails.logger.debug "Car Update Errors: #{@car.errors.full_messages.join(', ')}"
      render :edit, status: :unprocessable_entity
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
    if params[:pickup_date].present? && params[:return_date].present?
      @cars = @cars.where(
        "(availability_start_date <= ? AND availability_end_date >= ?) OR
         (availability_start_date <= ? AND availability_end_date >= ?) OR
         (availability_start_date >= ? AND availability_end_date <= ?)",
        params[:pickup_date], params[:pickup_date],
        params[:return_date], params[:return_date],
        params[:pickup_date], params[:return_date]
      )

      if params[:pickup_time].present? && params[:return_time].present?
        pickup_time = Time.parse(params[:pickup_time])
        return_time = Time.parse(params[:return_time])

        @cars = @cars.where(
          "(availability_start_time <= ? AND availability_end_time >= ?) OR
           (availability_start_time <= ? AND availability_end_time >= ?) OR
           (availability_start_time >= ? AND availability_end_time <= ?)",
          pickup_time, pickup_time,
          return_time, return_time,
          pickup_time, return_time
        )
      end
    end
    if params[:car_types].present?
      @cars = @cars.where(car_type: params[:car_types].split(','))
    end

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

  def confirm_vin
    vin = params[:vin]
    url = "https://vpic.nhtsa.dot.gov/api/vehicles/DecodeVinValues/#{vin}?format=json"
    response = HTTP.get(url)
    data = response.parse["Results"].first

    make = data["Make"]
    model = data["Model"]
    transmission = data["TransmissionStyle"]
    fuel_type = data["FuelTypePrimary"]
    number_of_doors = data["Doors"]
    engine_hp = data["EngineHP"]
    drive_type = data["DriveType"]
    body_class = data["BodyClass"]
    model_year = data["ModelYear"]

    render json: { car_name: model || "Not available", car_brand: make || "Not available", transmission: transmission || "Not available", fuel_type: fuel_type || "Not available", number_of_doors: number_of_doors || "Not available", engine_hp: engine_hp || "Not available", drive_type: drive_type || "Not available", body_class: body_class || "Not available", model_year: model_year || "Not available" }
  end

  private

  def set_car
    @car = Car.find_by(id: params[:id])
    unless @car
      redirect_to cars_url, alert: "Car not found."
    end
  end

  def set_car_types
    @car_types = ['Commercial', 'City', 'Sedan', 'Family', 'Minibus', '4x4', 'Convertible', 'Coupe', 'Antique', 'Campervan', 'SUV']
  end

  def car_params
    params.require(:car).permit(
      :car_name, :car_brand, :vin, :transmission, :fuel_type, :car_make,
      :image, :price_per_day, :number_of_seat, :status, :approved,
      :user_id, :latitude, :longitude, :address, :min_rental_duration,
      :max_rental_duration, :min_advance_notice, :availability_start_date,
      :availability_end_date, :availability_start_time, :availability_end_time,
      :owner_rules, :country, :car_type, :mileage,
      :number_of_doors, :instant_booking, features: []
    )
  end
end
