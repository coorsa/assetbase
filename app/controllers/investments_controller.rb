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
    authorize @investment
  end

  private

  def investment_price
    query = BasicYahooFinance::Query.new
    data = query.quotes(@investment.symbol)
    @info = data[@investment.symbol]
  end
end
