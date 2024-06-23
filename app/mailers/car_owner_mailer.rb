class CarOwnerMailer < ApplicationMailer
  def new_rental_request
    @rental = params[:rental]
    @car_owner = @rental.car.user
    mail(to: @car_owner.email, subject: 'New Rental Request')
  end
end
