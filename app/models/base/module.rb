class Base::Module < ApplicationRecord
  has_many :role_details

  validates :name, presence: true
  validates :description, presence: true
end
