class PortfoliosController < ApplicationController
  before_action :set_portfolio, only: [:show, :destroy]

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
  end

  def destroy
    @portfolio.user = current_user
    authorize @portfolio
    @portfolio.destroy
    redirect_to portfolios_path
  end

  private

  def portfolio_params
    params.require(:portfolio).permit(:title, :description)
  end

  def investment_price
    query = BasicYahooFinance::Query.new
    data = query.quotes(@portfolio.investment.symbol)
    @price = data[@portfolio.investment.symbol]['regularMarketPrice']
  end

  def set_portfolio
    @portfolio = Portfolio.find(params[:id])
  end

end
