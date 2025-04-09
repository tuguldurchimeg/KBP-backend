class V1::WorkspaceSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :created_at, :updated_at
  attribute :company do |object|
    V1::CompanySerializer.new(object.company)
  end
end
