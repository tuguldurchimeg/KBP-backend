class Document::FileDocument < ApplicationRecord
  belongs_to :document, foreign_key: :document_id, class_name: 'Document::Document'
  belongs_to :file, foreign_key: :file_id, class_name: 'Document::File'
end
