class Document::Document < ApplicationRecord
  belongs_to :workspace, foreign_key: :workspace_id, class_name: 'Base::Workspace'
  belongs_to :category, foreign_key: :category_id, class_name: 'Document::Category', optional: true
  belongs_to :user, foreign_key: :user_id, class_name: 'Base::User'
  has_many :issue_documents, class_name: 'Document::IssueDocument'
  has_many :tag_documents, class_name: 'Tool::TagDocument'

  validates :title, presence: true
end
