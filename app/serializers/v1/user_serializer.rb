class V1::UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :uid, :email, :firstname, :lastname, :avatar
  attribute :company do |object|
    CompanySerializer.new(object.company)
  end
end
