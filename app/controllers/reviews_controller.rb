class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_car

  def create
    @review = @car.reviews.new(review_params)
    @review.user = current_user
    if @review.save
      redirect_to @car, notice: 'Review was successfully created.'
    else
      redirect_to @car, alert: 'Review could not be created.'
    end
  end

  private

  def set_car
    @car = Car.find(params[:car_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
