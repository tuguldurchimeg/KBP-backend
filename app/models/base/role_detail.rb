class Base::RoleDetail < ApplicationRecord
  belongs_to :role
  belongs_to :module

  validates :role_id, presence: true
  validates :module_id, presence: true
end
