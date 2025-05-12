class V1::TagSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :color, :workspace_id, :created_at

  attribute :documents do |object|
    doc_ids = object.tag_documents.pluck(:document_id)
    docs = Document::Document.where(id: doc_ids)
    V1::DocumentSerializer.new(docs)
  end
end
