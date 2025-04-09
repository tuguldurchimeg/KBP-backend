class V1::DocumentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :content
  attribute :category do |object|
    V1::CategorySerializer.new(object.category)
  end

  attribute :tags do |object|
    V1::TagSerializer.new(object.tags)
  end

  attribute :author do |object|
    V1::UserSerializer.new(object.user)
  end
end
