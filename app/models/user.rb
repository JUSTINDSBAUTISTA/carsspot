class User < ApplicationRecord
  has_many :favorites
  has_many :cars, through: :favorites
  has_many :rentals
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
