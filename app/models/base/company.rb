class Base::Company < ApplicationRecord
  has_many :users, dependent: :destroy, class_name: 'Base::User'
  has_many :workspaces, dependent: :destroy, class_name: 'Base::Workspace'
  has_many :roles, dependent: :destroy, class_name: 'Base::Role'

  validates :uid, presence: true
  validates :name, presence: true
end
