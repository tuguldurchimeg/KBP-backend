class V1::IssueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :status, :priority, :created_at, :updated_at

  attribute :created_by do |object|
    V1::UserSerializer.new(object.user)
  end

  attribute :documents do |object|
    docs = Document::Document.where(id: object.issue_documents.select(:document_id))
    V1::DocumentSerializer.new(docs)
  end

  attribute :documents_count do |object|
    object.issue_documents.count
  end
end
