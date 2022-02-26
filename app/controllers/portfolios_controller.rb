class PortfoliosController < ApplicationController
  before_action :set_portfolio, only: [:show, :destroy, :edit, :update]

  def index
    @portfolios = policy_scope(Portfolio).order(created_at: :desc)
  end

  def new
    @portfolio = Portfolio.new
    authorize @portfolio
  end

  def create
    @portfolio = Portfolio.new(portfolio_params)
    @portfolio.user = current_user
    authorize @portfolio
    if @portfolio.save
      redirect_to portfolio_path(@portfolio)
    else
      render :new
    end
  end

  def show
    authorize @portfolio
    @portfolio_value = 0
    @portfolio.investments.each do |investment|
      investment.bookmarks.each do |bookmark|
        @portfolio_value += investment_price(investment)["regularMarketPrice"] * bookmark.quantity
      end
    end
  end

  def destroy
    @portfolio.user = current_user
    authorize @portfolio
    @portfolio.destroy
    redirect_to portfolios_path
  end

  def edit
    authorize @portfolio
  end

  def update
    authorize @portfolio
    if @portfolio.update(portfolio_params)
      redirect_to portfolio_path(@portfolio)
    else
      render :edit
    end
  end

  private

  def portfolio_params
    params.require(:portfolio).permit(:title, :description)
  end

  def investment_price(investment)
    query = BasicYahooFinance::Query.new
    data = query.quotes(investment.symbol)
    @info = data[investment.symbol]
  end

  def set_portfolio
    @portfolio = Portfolio.find(params[:id])
  end

end
