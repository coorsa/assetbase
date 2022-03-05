class PortfoliosController < ApplicationController
  require 'currency_converter'
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
    value = investment_price(portfolio_symbols)
    api_curr = "USD"
    @portfolio_value = Convert.new.currency(value, api_curr, current_user.currency)
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

  def investment_price(symbols)
    query = BasicYahooFinance::Query.new
    data = query.quotes(symbols)
    @value = 0
    @info = data
    @portfolio.investments.each do |investment|
      investment.bookmarks.each do |bookmark|
        @value += @info[investment.symbol]["regularMarketPrice"] * bookmark.quantity
      end
    end
    @value
  end

  def portfolio_symbols
    @symbols = []
    @portfolio.investments.each do |investment|
      @symbols.push(investment.symbol) unless @symbols.include?(investment.symbol)
    end
    @symbols
  end

  def set_portfolio
    @portfolio = Portfolio.find(params[:id])
  end

end
