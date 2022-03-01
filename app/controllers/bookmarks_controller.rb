class BookmarksController < ApplicationController
  before_action :set_investment, only: [:new, :create]
  before_action :set_portfolio, only: [:index, :show]

  def index
    @bookmarks = policy_scope(Bookmark).order(created_at: :desc)
    @query = params[:investment_id]
    if @query.present?
      @bookmarks = Bookmark.where(investment_id: @query, portfolio: @portfolio)
    else
      @bookmarks = Bookmark.all
    end
  end

  def show
    @bookmark = Bookmark.find(params[:id])
    authorize @bookmark
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
      redirect_to portfolio_path(@bookmark.portfolio), notice: "investment Added to your Portfolio 🎉"
    else
      render :new
    end
  end

  def edit
    @bookmark = Bookmark.find(params[:id])
    authorize @bookmark
  end

  def update
    @bookmark = Bookmark.find(params[:id])
    @bookmark.update(bookmark_params)
    authorize @bookmark
    redirect_to portfolio_path(@bookmark.portfolio), notice: "investment updated 🎉"
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:date, :quantity, :transaction_price, :comment, :transaction_type, :investment_id, :portfolio_id)
  end

  def set_investment
    @investment = Investment.find(params[:investment_id])
  end

  def set_portfolio
    @portfolio = Portfolio.find(params[:portfolio_id])
  end

  def match_portfolio_and_bookmark
    @portfolio = @bookmark.portfolio_id
  end
end
