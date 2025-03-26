class Document::Document < ApplicationRecord
  belongs_to :tag
  belongs_to :category
  belongs_to :user, foreign_key: :author_id
  has_many :issues

  validates :title, presence: true
  validates :content, presence: true
end
