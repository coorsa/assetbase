class RemoveAssetRefToBookmarks < ActiveRecord::Migration[6.1]
  def change
    remove_reference :bookmarks, :asset, foreign_key: false, index: true
  end
end
