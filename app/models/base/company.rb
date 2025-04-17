class Base::Company < ApplicationRecord
  has_many :users
  has_many :workspaces
  has_many :roles

  validates :uid, presence: true
  validates :name, presence: true
end
