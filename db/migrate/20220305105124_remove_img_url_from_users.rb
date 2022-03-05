class RemoveImgUrlFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :img_url
  end
end
