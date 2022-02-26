class PortfoliosController < ApplicationController
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
    @portfolio = Portfolio.find(params[:id])
    authorize @portfolio
    @portfolio_value = investment_price(portfolio_symbols)
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
end
