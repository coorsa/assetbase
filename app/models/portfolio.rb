class Portfolio < ApplicationRecord
  belongs_to :user

  has_many :bookmarks, dependent: :destroy
  has_many :investments, through: :bookmarks
end
