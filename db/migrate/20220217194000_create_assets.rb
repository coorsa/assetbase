class CreateAssets < ActiveRecord::Migration[6.1]
  def change
    create_table :assets do |t|
      t.string :name
      t.string :category
      t.string :symbol

      t.timestamps
    end
  end
end
