# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

Portfolio.destroy_all
Bookmark.destroy_all
Asset.destroy_all
User.destroy_all

puts "creating assets"
bitcoin = Asset.create!(name: "Bitcoin", category: "Crypto", symbol: "BTC")
csv_text = File.read(Rails.root.join('lib', 'seeds', 'stocks_list.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  a = Asset.new
  a.name = row["Description"]
  a.category = "share"
  a.symbol = row["Symbol"]
  a.save
end
puts "created assets"

puts "creating users"
user_1 = User.create!(email: "rujyq@zetmail.com", password: "Frog123")
puts "created users"

puts "creating portfolio"
portfolio_1 = Portfolio.create!(title: "Test", description: "Test portfolio", user_id: user_1.id)
puts "created portfolio"

puts "creating bookmark"
a = Asset.last
Bookmark.create!(portfolio_id: portfolio_1.id, asset_id: a.id, transaction_price: 100, transaction_type: "Buy", quantity: 1, date: "18/02/2022", comment: "test")
Bookmark.create!(portfolio_id: portfolio_1.id, asset_id: a.id, transaction_price: 100, transaction_type: "Buy", quantity: 2, date: "19/02/2022", comment: "test")
Bookmark.create!(portfolio_id: portfolio_1.id, asset_id: bitcoin.id, transaction_price: 150, transaction_type: "Buy", quantity: 1, date: "18/02/2022", comment: "test2")
puts "created bookmark"
