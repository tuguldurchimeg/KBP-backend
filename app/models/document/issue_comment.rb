class Document::IssueComment < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, class_name: 'Base::User'
  belongs_to :issue, foreign_key: :issue_id, class_name: 'Document::Issue'

  validates :comment, presence: true
end
