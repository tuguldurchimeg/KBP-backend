class V1::FileSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :file_type, :size, :url, :workspace_id, :created_at, :updated_at

  attribute :uploader do |object|
    V1::UserSerializer.new(object.user)
  end

  attribute :documents do |object|
    docs = Document::Document.where(id: object.file_documents.select(:document_id))
    V1::DocumentSerializer.new(docs)
  end
end
