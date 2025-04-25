class Base::Category < ApplicationRecord
  belongs_to :workspace, foreign_key: :workspace_id, class_name: 'Base::Workspace'
  has_many :documents

  validates :name, presence: true
end
