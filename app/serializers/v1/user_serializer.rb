class V1::UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :uid, :email, :firstname, :lastname, :avatar
  attribute :company do |object|
    V1::CompanySerializer.new(object.company)
  end
end
