class Tool::Tag < ApplicationRecord
  belongs_to :workspace, class_name: 'Base::Workspace', foreign_key: :workspace_id
  has_many :document_tags, class_name: 'Tool::DocumentTag'
  validates :name, presence: true
end
