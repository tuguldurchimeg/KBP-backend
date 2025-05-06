class V1::DocumentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :content, :created_at, :updated_at, :is_template
  show_detail = proc do |record, params|
    params[:show_detail]
  end
  attribute :category, if: show_detail do |object|
    V1::CategorySerializer.new(object.category)
  end

  attribute :tags, if: show_detail do |object|
    tag_ids = object.document_tags.pluck(:tag_id)
    tags = Tool::Tag.where(id: tag_ids)
    V1::TagSerializer.new(tags)
  end

  attribute :user do |object|
    V1::UserSerializer.new(object.user)
  end

  attribute :category, if: show_detail do |object|
    V1::CategorySerializer.new(object.category)
  end
  attribute :workspace_id do |object|
    object.category.workspace_id
  end
end
