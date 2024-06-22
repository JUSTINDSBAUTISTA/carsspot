class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @cars = Car.where(status: 'approved')
    authorize :page, :home?
  end
end
