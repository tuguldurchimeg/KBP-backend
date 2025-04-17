class Base::RoleDetail < ApplicationRecord
  belongs_to :role
  belongs_to :module

  validates :role_id, presence: true
  validates :module_id, presence: true
  enum :action, { admin: 99, read: 1, write: 2}
end
