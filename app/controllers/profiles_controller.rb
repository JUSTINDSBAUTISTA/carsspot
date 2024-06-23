class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    authorize @user
  end

  def edit
    @user = current_user
    authorize @user
  end

  def update
    @user = current_user
    authorize @user
    if @user.update(user_params)
      bypass_sign_in(@user) if user_params[:password].present?
      redirect_to profile_path, notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :birthday, :phone_number, :address, :zip_code, :town, :country, :about_me)
  end
end
