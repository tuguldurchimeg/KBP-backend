class Company < ApplicationRecord
  has_many :users
  has_many :workspaces

  validates :uid, presence: true
  validates :name, presence: true
end
