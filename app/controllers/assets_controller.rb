class AssetsController < ApplicationController
  def index
    @query = params[:query]
    if @query.present?
      @query.slice!("asset")
      @saunas = Asset.search_by_name_category_and_symbol(@query)
    else
      @saunas = Asset.all
    end
  end

  def show
    @asset = Asset.find(params[:id])
  end
end
