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
    if user_params[:id]
      redirect_to profile_path
    else
      redirect_to portfolio_path
    end
  end

  private

  def user_params
    params.require("user").permit(:email, :name, :currency, :photo)
  end
end
