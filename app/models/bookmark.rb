class Bookmark < ApplicationRecord
  belongs_to :portfolio
  belongs_to :asset

  validates :transaction_price, presence: true
  validates :transaction_type, presence: true
  validates :quantity, presence: true
  validates :date, presence: true
end
