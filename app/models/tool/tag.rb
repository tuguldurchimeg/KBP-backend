class Tool::Tag < ApplicationRecord
  belongs_to :workspace, class_name: 'Base::Workspace', foreign_key: :workspace_id
  has_many :tag_documents, class_name: 'Tool::TagDocument'
  validates :name, presence: true

  default_scope { where(workspace_id: Base::Workspace.select(:id)) }
end
