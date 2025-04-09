class V1::CategorySerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :type, :description
  attribute :workspace do |object|
    V1::WorkspaceSerializer.new(object.company)
  end
end
