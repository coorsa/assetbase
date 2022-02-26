class UsersController < ApplicationController
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
    @user.update(user_params)
    authorize @user
  end

  private

  def user_params
    params.require(:user).permit(:name, :address, :currency)
  end
end
