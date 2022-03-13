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
      redirect_to portfolio_path(portfolio_param[:portfolio].to_i)
    end
  end

  private

  def portfolio_param
    params.require("user").permit(:portfolio)
  end

  def user_params
    params.require("user").permit(:email, :name, :currency, :photo)
  end
end
