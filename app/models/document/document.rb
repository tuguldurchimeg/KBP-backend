class Document::Document < ApplicationRecord
  belongs_to :category, foreign_key: :category_id
  belongs_to :user, foreign_key: :user_id
  has_many :issue_documents, class_name: 'Document::IssueDocument'
  has_many :document_tags, class_name: 'Document::DocumentTag'

  validates :title, presence: true
  validates :content, presence: true
end
