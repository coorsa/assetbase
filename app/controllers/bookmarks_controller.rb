class BookmarksController < ApplicationController
  before_action :set_asset

  def new
    @bookmark = Bookmark.new
    # authorize @bookmark

  end

  def create
    raise
    @bookmark = Bookmark.new(bookmark_params)
    @bookmark.user = current_user
    @bookmark.asset = @asset
    # authorize @bookmark

    if @bookmark.save
      redirect_to assets_path, notice: "Asset Added to your Portfolio 🎉"
    else
      render :new
    end
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:date, :quantity, :transaction_price, :comment, :transaction_type, :asset_id, :portfolio_id)
  end

  def set_asset
    @asset = Asset.find(params[:asset_id])
  end
end
