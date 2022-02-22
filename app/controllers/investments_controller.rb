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
    elsif @investment.category == "share"
      historical_stocks
    end
    authorize @investment
  end

  private

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

  def historical_stocks
    timeseries = Alphavantage::Timeseries.new symbol: @investment.symbol, key: "9W4H6IM5X71T33KS"
    @time_array = timeseries.close("desc").first(50)
  end
end
