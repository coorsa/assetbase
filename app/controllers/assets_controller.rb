class AssetsController < ApplicationController
  def index
    @query = params[:query]
    if @query.present?
      @query.slice!("asset")
      @assets = Asset.search_by_name_category_and_symbol(@query)
    else
      @assets = Asset.all
    end
  end

  def show
    @asset = Asset.find(params[:id])
    asset_price
  end

private
  def asset_price
    query = BasicYahooFinance::Query.new
    data = query.quotes(@asset.symbol)
    @info = data[@asset.symbol]
  end
end
