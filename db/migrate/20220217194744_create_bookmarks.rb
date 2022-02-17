class CreateBookmarks < ActiveRecord::Migration[6.1]
  def change
    create_table :bookmarks do |t|
      t.references :portfolio, null: false, foreign_key: true
      t.references :asset, null: false, foreign_key: true
      t.float :transaction_price
      t.string :transaction_type
      t.float :quantity
      t.string :date
      t.text :comment

      t.timestamps
    end
  end
end
