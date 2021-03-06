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
Investment.destroy_all
User.destroy_all

puts "creating crypto"
bitcoin = Investment.create!(name: "Bitcoin", category: "crypto", symbol: "BTC-USD")
dogecoin = Investment.create!(name: "Dogecoin", category: "crypto", symbol: "DOGE-USD")
ethereum = Investment.create!(name: "Ethereum", category: "crypto", symbol: "ETH-USD")
polkadot = Investment.create!(name: "Polkadot", category: "crypto", symbol: "DOT-USD")
pancakeswap = Investment.create!(name: "PancakeSwap", category: "crypto", symbol: "CAKE-USD")
puts "created crypto"

puts 'creating NFTs'
Investment.create!(name: "Mutant Ape Yacht Club", category: "NFT", symbol: "Mutant Ape Yacht Club")
Investment.create!(name: "Doodles", category: "NFT", symbol: "Doodles")
puts 'created NFTs'


puts "creating shares"
csv_text = File.read(Rails.root.join('lib', 'seeds', 'stocks_list.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  a = Investment.new
  a.name = row["Description"]
  a.category = "share"
  a.symbol = row["Symbol"]
  a.save
end
puts "created shares"

puts "finding previous prices"
last_investment = Investment.last
investments = [last_investment, bitcoin, pancakeswap, ethereum, dogecoin, polkadot]
investments.each do |investment|
  investment.previous_price = BasicYahooFinance::Query.new.quotes(Investment.find(investment.id).symbol)[Investment.find(investment.id).symbol]["regularMarketPrice"]
  investment.save!
  sleep(5)
end
puts "finished finding previous prices"

puts "creating user(s)"
user_1 = User.create!(name: "André Ferrer", email: "rujyq@zetmail.com", password: "Frog123", currency: "BRL")
puts "created users"

puts "creating portfolios"
portfolio_1 = Portfolio.create!(title: "YOLO FUND", description: "$$$$$$$$$!", user_id: user_1.id)
portfolio_2 = Portfolio.create!(title: "Zero Research", description: "HODL", user_id: user_1.id)
portfolio_3 = Portfolio.create!(title: "Hopium", description: "My Retirement (Maybe....)", user_id: user_1.id)
puts "created portfolios"

puts "creating bookmark 1"
a = Investment.last
Bookmark.create!(portfolio_id: portfolio_1.id, investment_id: a.id, transaction_price: 100, transaction_type: "Buy", quantity: 1, date: "18/02/2022", comment: "stonks")
Bookmark.create!(portfolio_id: portfolio_1.id, investment_id: a.id, transaction_price: 100, transaction_type: "Buy", quantity: 2, date: "19/02/2022", comment: "no clue what they do!")
Bookmark.create!(portfolio_id: portfolio_1.id, investment_id: bitcoin.id, transaction_price: 150, transaction_type: "Buy", quantity: 1, date: "18/02/2022", comment: "Tesla cash")
Bookmark.create!(portfolio_id: portfolio_1.id, investment_id: pancakeswap.id, transaction_price: 100_000, transaction_type: "Buy", quantity: 1, date: "18/02/2022", comment: "<3 PANCAKES")
puts "creating bookmark 2"

tesla = Investment.find_by(symbol: "TSLA")
Bookmark.create!(portfolio_id: portfolio_2.id, investment_id: tesla.id, transaction_price: 100_000, transaction_type: "Buy", quantity: 1, date: "18/02/2019", comment: "test3")
gamestop = Investment.find_by(symbol: "GME")
Bookmark.create!(portfolio_id: portfolio_2.id, investment_id: gamestop.id, transaction_price: 100_000, transaction_type: "Buy", quantity: 1, date: "18/02/2019", comment: "test3")
Bookmark.create!(portfolio_id: portfolio_2.id, investment_id: ethereum.id, transaction_price: 9_000, transaction_type: "Buy", quantity: 1, date: "18/02/2022", comment: "test3")
Bookmark.create!(portfolio_id: portfolio_2.id, investment_id: dogecoin.id, transaction_price: 100, transaction_type: "Buy", quantity: 1, date: "18/02/2022", comment: "test4")
Bookmark.create!(portfolio_id: portfolio_2.id, investment_id: pancakeswap.id, transaction_price: 10, transaction_type: "Buy", quantity: 1, date: "18/02/2022", comment: "test5")
puts "creating bookmark 3"
Bookmark.create!(portfolio_id: portfolio_3.id, investment_id: ethereum.id, transaction_price: 100, transaction_type: "Buy", quantity: 1, date: "18/02/2022", comment: "test3")
Bookmark.create!(portfolio_id: portfolio_3.id, investment_id: dogecoin.id, transaction_price: 100_000, transaction_type: "Buy", quantity: 1, date: "18/02/2022", comment: "test4")
Bookmark.create!(portfolio_id: portfolio_3.id, investment_id: pancakeswap.id, transaction_price: 10_000_000, transaction_type: "Buy", quantity: 1, date: "18/02/2022", comment: "test5")
Bookmark.create!(portfolio_id: portfolio_3.id, investment_id: polkadot.id, transaction_price: 0.1, transaction_type: "Buy", quantity: 1, date: "18/02/2022", comment: "test6")
puts "created bookmarks"
