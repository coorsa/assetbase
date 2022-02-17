class Asset < ApplicationRecord
  has_many :bookmarks

  validates :name, presence: true
  validates :category, presence: true
  validates :symbol, uniqueness: true
end
