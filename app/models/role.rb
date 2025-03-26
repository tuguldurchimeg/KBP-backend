class Role < ApplicationRecord
  has_many :users
  has_many :role_details

  validates :name, presence: true
  validates :description, presence: true
end
