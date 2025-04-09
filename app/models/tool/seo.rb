
class Tool::Seo < ApplicationRecord
  belongs_to :document, class_name: 'Document::Document'

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, length: { maximum: 1000 }
  validates :document_id, only_integer: true

  scope :recent, -> { order(created_at: :desc) }

  before_save :sanitize_fields

  private

  def sanitize_fields
    self.title = title.strip if title.present?
    self.description = description.strip if description.present?
    self.keywords = keywords.strip if keywords.present?
  end
end
