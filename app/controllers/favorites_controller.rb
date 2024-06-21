class FavoritesController < ApplicationController
  def index
    @favorites = policy_scope(Favorite)
    authorize @favorites
  end

  def show
    @favorite = Favorite.find(params[:id])
    authorize @favorite
  end

  def new
    @favorite = Favorite.new
    authorize @favorite
  end

  def create
    @favorite = Favorite.new(favorite_params)
    authorize @favorite
    if @favorite.save
      redirect_to @favorite, notice: 'Favorite was successfully created.'
    else
      render :new
    end
  end

  def edit
    @favorite = Favorite.find(params[:id])
    authorize @favorite
  end

  def update
    @favorite = Favorite.find(params[:id])
    authorize @favorite
    if @favorite.update(favorite_params)
      redirect_to @favorite, notice: 'Favorite was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    authorize @favorite
    @favorite.destroy
    redirect_to favorites_url, notice: 'Favorite was successfully destroyed.'
  end

  private

  def favorite_params
    params.require(:favorite).permit(:attribute)
  end
end
