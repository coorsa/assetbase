class BookmarksController < ApplicationController
  before_action :set_investment, only: [:new, :create]
  before_action :set_portfolio, only: [:index, :show, :edit, :update]

  def index
    @bookmarks = policy_scope(Bookmark).order(created_at: :desc)
    @query = params[:investment_id]
    if @query.present?
      @bookmarks = Bookmark.where(investment_id: @query, portfolio: @portfolio)
    else
      @bookmarks = Bookmark.all
    end
  end

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
      redirect_to portfolio_path(@bookmark.portfolio_id), notice: "investment Added to your Portfolio 🎉"
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
