class Document::IssueDocument < ApplicationRecord
  belongs_to :document, foreign_key: :document_id, class_name: 'Document::Document'
  belongs_to :issue, foreign_key: :issue_id, class_name: 'Document::Issue'

end
