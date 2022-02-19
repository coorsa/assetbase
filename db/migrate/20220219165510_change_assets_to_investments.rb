class ChangeAssetsToInvestments < ActiveRecord::Migration[6.1]
  def change
    rename_table :assets, :investments
  end
end
