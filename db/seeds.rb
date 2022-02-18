# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Asset.destroy_all

puts "creating assets"
asset_1 = Asset.create!(name: "Google", category: "Share", symbol: "GOOGL")
asset_2 = Asset.create!(name: "Apple", category: "Share", symbol: "AAPL")
asset_2 = Asset.create!(name: "Bitcoin", category: "Crypto", symbol: "BTC")
puts "created users"

puts "creating users"
user_1 = User.create!(email: "rujyq@zetmail.com", password: "Frog123")
puts "created users"

puts "creating portfolio"
portfolio_1 = Portfolio.create!(title: "Test", description: "Test portfolio", user_id: user_1.id)
puts "created portfolio"

puts "creating bookmark"
Bookmark.create!(portfolio_id: portfolio_1.id, asset_id: asset_1.id, transaction_price: "100", transaction_type: "Buy", quantity: 1, date: 18/02/2022, comment: "test")
Bookmark.create!(portfolio_id: portfolio_1.id, asset_id: asset_2.id, transaction_price: "150", transaction_type: "Buy", quantity: 1, date: 18/02/2022, comment: "test2")
puts "created bookmark"
