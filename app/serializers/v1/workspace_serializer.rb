class V1::WorkspaceSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :image_url, :created_at, :updated_at
  show_detail = proc do |record, params|
    params[:show_detail]
  end

  attribute :company, if: show_detail do |object|
    V1::CompanySerializer.new(object.company)
  end

  attribute :categories, if: show_detail do |object, params|
    V1::CategorySerializer.new(object.categories.where(parent_id: nil), params: { show_detail: true, tag_ids: params[:tag_ids] } )
  end

  attribute :documents, if: show_detail do |object, params|
    docs = object.documents.where(category_id: nil, is_template: false)
    docs = docs.left_joins(:tag_documents).where(tag_documents: { tag_id: params[:tag_ids]}).uniq if params[:tag_ids].present?
    V1::DocumentSerializer.new(docs)
  end

  attribute :issues, if: show_detail do |object|
    V1::IssueSerializer.new(object.issues)
  end

  attribute :tags, if: show_detail do |object|
    V1::TagSerializer.new(object.tags)
  end
end
