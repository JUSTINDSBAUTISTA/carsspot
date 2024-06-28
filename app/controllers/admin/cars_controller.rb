# app/controllers/admin/cars_controller.rb
class Admin::CarsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  def index
    @cars = Car.where(status: 'pending')
    @markers = @cars.map do |car|
      {
        lat: car.latitude,
        lng: car.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { car: car })
      }
    end
  end

  def approve
    @car = Car.find(params[:id])
    @car.update(status: 'approved')
    redirect_to admin_cars_path, notice: 'Car approved successfully.'
  end

  private

  def authorize_admin!
    redirect_to root_path, alert: 'Access denied!' unless current_user.admin?
  end
end
