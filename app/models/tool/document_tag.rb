class Document::DocumentTag < ApplicationRecord
  belongs_to :document, foreign_key: :document_id, class_name: 'Document::Document'
  belongs_to :tag, foreign_key: :tag_id, class_name: 'Tool::Tag'

end
