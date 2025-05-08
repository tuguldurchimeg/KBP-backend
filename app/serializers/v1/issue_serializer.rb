class V1::IssueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :status, :priority, :issue_type, :workspace_id, :created_at, :updated_at

  show_detail = proc do |record, params|
    params[:show_detail]
  end

  attribute :created_by do |object|
    V1::UserSerializer.new(object.user)
  end

  attribute :documents, if: show_detail do |object|
    docs = Document::Document.where(id: object.issue_documents.select(:document_id))
    V1::DocumentSerializer.new(docs)
  end

  attribute :documents_count do |object|
    object.issue_documents.length
  end

  attribute :assignees do |object|
    issue_users = Base::User.where(id: object.issue_assignees.select(:id))
    V1::UserSerializer.new(issue_users)
  end
end
