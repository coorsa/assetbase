class Portfolio < ApplicationRecord
  belongs_to :user

  has_many :bookmarks, dependent: :destroy
  has_many :assets, through: :bookmarks
end
