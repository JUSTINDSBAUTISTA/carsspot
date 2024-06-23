class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_car

  def new
    @review = @car.reviews.new
  end

  def create
    @review = @car.reviews.new(review_params)
    @review.user = current_user
    if @review.save
      redirect_to @car, notice: 'Review was successfully created.'
    else
      render :new
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
