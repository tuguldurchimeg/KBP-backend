class V1::DocumentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :content, :view_count, :created_at, :updated_at, :is_template
  show_detail = proc do |record, params|
    params[:show_detail]
  end

  attribute :tags, if: show_detail do |object|
    tag_ids = object.tag_documents.pluck(:tag_id)
    tags = Tool::Tag.where(id: tag_ids)
    V1::TagSerializer.new(tags)
  end

  attribute :user do |object|
    V1::UserSerializer.new(object.user)
  end

  attribute :category do |object|
    V1::CategorySerializer.new(object.category)
  end

  attribute :workspace_id do |object|
    object.workspace&.id
  end
end
