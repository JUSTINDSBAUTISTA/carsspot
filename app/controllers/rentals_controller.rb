class RentalsController < ApplicationController
  def index
    @rentals = policy_scope(Rental)
    authorize @rentals
  end

  def show
    @rental = Rental.find(params[:id])
    authorize @rental
  end

  def new
    @rental = Rental.new
    authorize @rental
  end

  def create
    @rental = Rental.new(rental_params)
    authorize @rental
    if @rental.save
      redirect_to @rental, notice: 'Rental was successfully created.'
    else
      render :new
    end
  end

  def edit
    @rental = Rental.find(params[:id])
    authorize @rental
  end

  def update
    @rental = Rental.find(params[:id])
    authorize @rental
    if @rental.update(rental_params)
      redirect_to @rental, notice: 'Rental was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @rental = Rental.find(params[:id])
    authorize @rental
    @rental.destroy
    redirect_to rentals_url, notice: 'Rental was successfully destroyed.'
  end

  private

  def rental_params
    params.require(:rental).permit(:attribute)
  end
end
