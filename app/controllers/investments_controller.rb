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
    currency_symbol
    if @investment.category == "Crypto"
      investment_price
      historical_crypto
    elsif @investment.category == "share"
      investment_price
      historical_stocks
      company_info
    elsif @investment.category == "NFT"
      nft_info
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
    if @info["regularMarketPrice"].nil? == false && @investment.previous_price != @info["regularMarketPrice"]
      @investment.previous_price = @info["regularMarketPrice"]
      @investment.save!
    end
  end

  def historical_crypto
    data = Cryptocompare::HistoDay.find(@info["fromCurrency"], "USD")["Data"]
    @array = []
    data.each do |item|
      @array << [Time.at(item["time"]).to_date.to_s, item["close"]]
    end
  end

  def historical_stocks
    if @investment.symbol.present?
      timeseries = Alphavantage::Timeseries.new symbol: @investment.symbol, key: ENV['ALPHAVANTAGE_KEY']
      @time_array = timeseries.close("desc").first(50)
    end
  end

  def company_info
    Clearbit.key = ENV['CLEARBIT_KEY']
    if @info && @info["displayName"].present?
      @clearbit = Clearbit::NameDomain.find(name: @info["displayName"])
    else
      @clearbit = Clearbit::NameDomain.find(name: @investment.name)
    end
  end

  def nft_info
    chars = @investment.symbol.chars
    hyph_name = chars.map { |e| e == " " ? '-' : e.downcase }.join
    url = "https://opensea.io/collection/#{hyph_name}"
    html_content = HTTParty.get(url).body
    doc = Nokogiri::HTML(html_content)
    css = ".Overflowreact__OverflowContainer-sc-7qr9y8-0"
    array = []

    doc.search(css).first(5).each do |element|
      array << element.text.strip
    end

    ethereum_price = Cryptocompare::Price.find('ETH', current_user.currency, { api_key: ENV['CRYPTOCOMPARE_KEY'] })
    @nft_info = { items: array[0], owners: array[1], floor_price: array[2],
                  floor_price_fiat: array[2].to_f * ethereum_price["ETH"][current_user.currency],
                  volume_traded: array[3], name: array[4], hyph_name: hyph_name }

    if @investment.previous_price != @nft_info[:floor_price]
      @investment.previous_price = @nft_info[:floor_price]
      @investment.save!
    end
  end

  def currency_symbol
    @currency = ISO4217::Currency.from_code(current_user.currency).symbol
  end
end
