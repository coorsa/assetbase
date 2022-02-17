class Bookmark < ApplicationRecord
  belongs_to :portfolio
  belongs_to :asset
end
