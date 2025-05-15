class Base::Role < ApplicationRecord
  has_many :users
  has_many :role_details
  belongs_to :company, class_name: 'Base::Company', foreign_key: :company_id

  validates :name, presence: true
end
