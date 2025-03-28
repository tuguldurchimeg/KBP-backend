class V1::CompanySerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :uid
end
