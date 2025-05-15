class V1::WorkspaceRoleDetailSerializer
  include FastJsonapi::ObjectSerializer
  attributes :action
  attribute :user do |object|
    V1::UserSerializer.new(object.user)
  end
  attribute :workspace do |object|
    V1::WorkspaceSerializer.new(object.workspace)
  end
end
