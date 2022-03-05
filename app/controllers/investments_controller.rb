class InvestmentsController < ApplicationController
  def index
    @investments = policy_scope(Investment).order(created_at: :desc)
    @investment_category = @investments.group_by(&:category).keys.to_a

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
    if @investment.category == "crypto"
      historical_crypto
    elsif @investment.category == "share"
      historical_stocks
      company_info
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
    data = Cryptocompare::HistoDay.find(@info["fromCurrency"], 'USD')["Data"]
    @array = []
    data.each do |item|
      @array << [Time.at(item["time"]).to_date.to_s, item["close"]]
    end
  end

  def historical_stocks
    timeseries = Alphavantage::Timeseries.new symbol: @investment.symbol, key: ENV['ALPHAVANTAGE_KEY']
    @time_array = timeseries.close("desc").first(50)
  end

  def company_info
    Clearbit.key = ENV['CLEARBIT_KEY']
    if @info && @info["displayName"].present?
      @clearbit = Clearbit::NameDomain.find(name: @info["displayName"])
    else
      @clearbit = Clearbit::NameDomain.find(name: @investment.name)
    end
  end
end
