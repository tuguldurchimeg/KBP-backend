class V1::CategorySerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :parent_id
  # attribute :workspace do |object|
  #   V1::WorkspaceSerializer.new(object.company)
  # end
  attribute :subcategories do |object|
    subs = Document::Category.where(parent_id: object.id)
    V1::CategorySerializer.new(subs)
  end

  attribute :documents do |object|
    V1::DocumentSerializer.new(object.documents)
  end
end
