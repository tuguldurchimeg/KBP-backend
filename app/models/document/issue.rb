class Document::Issue < ApplicationRecord
  belongs_to :workspace, class_name: 'Base::Workspace'
  belongs_to :created_by, class_name: 'Base::User'
  belongs_to :assignee, class_name: 'Base::User', optional: true
  belongs_to :document, class_name: 'Document::Document', optional: true
  has_many :issue_comments

  validates :status, presence: true
  validates :priority, presence: true

  enum status: {
    open: 0,
    in_progress: 1,
    closed: 2,
    on_hold: 3,
  }
end
