class Car < ApplicationRecord
  has_many :users, through: :favorites
  has_many :rentals
end
