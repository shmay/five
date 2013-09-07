class Game < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_and_belongs_to_many :groups

  has_many :playings
  has_many :users, through: :playings

  validates :name, uniqueness: true
end
