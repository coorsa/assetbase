class PortfoliosController < ApplicationController

  def new
    @portfolio = Portfolio.new
    # authorize @portfolio
  end

  def create
    @portfolio = Portfolio.new(portfolio_params)
    @portfolio.user = current_user
    # authorize @portfolio
    if @portfolio.save
      redirect_to portfolio_path(@portfolio)
    else
      render :new
    end
  end

  def index

  end

  def show
    @portfolio = Portfolio.find(params[:id])
    # authorize @portfolio
    # asset_price
  end

  private

  def portfolio_params
    params.require(:portfolio).permit(:title, :description)
  end

  def asset_price
    query = BasicYahooFinance::Query.new
    data = query.quotes(@portfolio.asset.symbol)
    @price = data[@portfolio.asset.symbol]['regularMarketPrice']
  end

end
