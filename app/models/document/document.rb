class Document::Document < ApplicationRecord
  belongs_to :tag
  belongs_to :category, foreign_key: :category_id
  belongs_to :user, foreign_key: :user_id
  has_many :issues

  validates :title, presence: true
  validates :content, presence: true
end
