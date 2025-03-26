class Document::Issue < ApplicationRecord
  belongs_to :document
  belongs_to :created_by, class_name: 'User'
  belongs_to :assignee, class_name: 'User', optional: true
  has_many :issue_comments

  validates :status, presence: true
  validates :priority, presence: true
end
