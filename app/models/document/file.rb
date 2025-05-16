class Document::File < ApplicationRecord
  belongs_to :workspace, class_name: 'Base::Workspace', foreign_key: :workspace_id
  belongs_to :user, class_name: 'Base::User', foreign_key: :user_id # uploader
  has_many :file_documents, class_name: 'Document::FileDocument'

  validates :url, presence: true

  default_scope { where(workspace_id: Base::Workspace.select(:id)) }
end
