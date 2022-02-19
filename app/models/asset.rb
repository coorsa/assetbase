class Asset < ApplicationRecord
  has_many :bookmarks

  include PgSearch::Model
  pg_search_scope :search_by_name_category_and_symbol,
    against: [ :name, :category, :symbol ],
    using: {
      tsearch: { prefix: true }
    }
  validates :name, presence: true
  validates :category, presence: true
  validates :symbol, uniqueness: true
end
