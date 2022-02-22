class InvestmentsController < ApplicationController
  def index
    @investments = policy_scope(Investment).order(created_at: :desc)

    @query = params[:query]
    if @query.present?
      @query.slice!("investment")
      @investments = Investment.search_by_name_category_and_symbol(@query)
    else
      @investments = Investment.all
    end
  end

  def show
    @investment = Investment.find(params[:id])
    investment_price
    if @investment.category == "Crypto"
      historical_crypto
    end
    authorize @investment
  end

  def new
    @investment = Investment.new
    authorize @investment
  end

  def create
    @investment = Investment.new(investment_params)
    authorize @investment

    if @investment.save
      redirect_to investment_path(@investment)
    else
      render :new
    end
  end

  private

  def investment_params
    params.require(:investment).permit(:name, :category, :symbol)
  end

  def investment_price
    query = BasicYahooFinance::Query.new
    data = query.quotes(@investment.symbol)
    @info = data[@investment.symbol]
  end

  def historical_crypto
    @one_day_ago = Cryptocompare::PriceHistorical.find(@info["fromCurrency"], 'USD', {'ts' => 1.day.ago.strftime('%s') })
    @seven_day_ago = Cryptocompare::PriceHistorical.find(@info["fromCurrency"], 'USD', {'ts' => 7.day.ago.strftime('%s') })
    @fourteen_day_ago = Cryptocompare::PriceHistorical.find(@info["fromCurrency"], 'USD', {'ts' => 14.day.ago.strftime('%s') })
    @twentyone_day_ago = Cryptocompare::PriceHistorical.find(@info["fromCurrency"], 'USD', {'ts' => 21.day.ago.strftime('%s') })
    @twentyeight_day_ago = Cryptocompare::PriceHistorical.find(@info["fromCurrency"], 'USD', {'ts' => 28.day.ago.strftime('%s') })
  end
end
