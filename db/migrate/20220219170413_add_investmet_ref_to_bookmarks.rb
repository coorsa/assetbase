class AddInvestmetRefToBookmarks < ActiveRecord::Migration[6.1]
  def change
    add_reference :bookmarks, :investment, null: false, foreign_key: true
  end
end
