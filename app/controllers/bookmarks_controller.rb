class BookmarksController < ApplicationController
  before_action :set_investment

  def new
    @bookmark = Bookmark.new
    authorize @bookmark

  end

  def create
    @bookmark = Bookmark.new(bookmark_params)
    # @bookmark.user = current_user
    @bookmark.investment = @investment
    authorize @bookmark

    if @bookmark.save
      redirect_to portfolio_path(@bookmark.portfolio), notice: "investment Added to your Portfolio 🎉"
    else
      render :new
    end
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:date, :quantity, :transaction_price, :comment, :transaction_type, :investment_id, :portfolio_id)
  end

  def set_investment
    @investment = Investment.find(params[:investment_id])
  end
end
