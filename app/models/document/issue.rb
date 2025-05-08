class Document::Issue < ApplicationRecord
  belongs_to :workspace, class_name: 'Base::Workspace', foreign_key: :workspace_id
  belongs_to :user, class_name: 'Base::User', foreign_key: :created_by
  has_many :issue_comments, class_name: 'Document::IssueComment'
  has_many :issue_assignees, class_name: 'Document::IssueAssignee'
  has_many :issue_documents, class_name: 'Document::IssueDocument'

  enum status: { open: 0, in_progress: 1, closed: 2 }
  enum priority: { low: 0, medium: 1, high: 2,  }
  enum issue_type: { problem: 0, question: 1 }

end
