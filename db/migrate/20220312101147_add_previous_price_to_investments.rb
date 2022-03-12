class AddPreviousPriceToInvestments < ActiveRecord::Migration[6.1]
  def change
    add_column :investments, :previous_price, :float
  end
end
