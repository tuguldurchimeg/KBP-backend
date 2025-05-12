class V1::WorkspaceSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :image_url, :created_at, :updated_at
  show_detail = proc do |record, params|
    params[:show_detail]
  end

  attribute :company, if: show_detail do |object|
    V1::CompanySerializer.new(object.company)
  end

  attribute :categories, if: show_detail do |object|
    V1::CategorySerializer.new(object.categories)
  end

  attribute :documents, if: show_detail do |object|
    V1::DocumentSerializer.new(object.documents.where(category_id: nil, is_template: false))
  end

  attribute :issues, if: show_detail do |object|
    V1::IssueSerializer.new(object.issues)
  end
end
