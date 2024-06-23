class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  skip_after_action :verify_policy_scoped, only: :home

  def home
    @cars = Car.where(status: 'approved').limit(3)
    authorize :page, :home?
  end
end
