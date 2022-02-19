class BookmarksController < ApplicationController
  def new
    @bookmark = Bookmark.new
    # authorize @bookmark
  end

  def create
    @bookmark = Bookmark.new(bookmark_params)
    # @bookmark.user = current_user
    # authorize @bookmark
    if @bookmark.save
      redirect_to asset_path(@asset), notice: "Your booking has been completed 🎉"
    else
      render :new
    end
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:date, :quantity, :transaction_price, :comment, :transaction_type, :asset_id, :portfolio_id)
  end

end
