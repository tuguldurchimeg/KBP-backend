
class Tool::Seo < ApplicationRecord
  belongs_to :document, class_name: 'Document::Document'

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, length: { maximum: 1000 }
  validates :document_id, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
