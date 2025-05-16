class V1::UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :uid, :email, :firstname, :lastname, :avatar
  show_issue = proc do |record, params|
    params[:show_issue]
  end

  attribute :company do |object|
    V1::CompanySerializer.new(object.company)
  end

  attribute :issues, if: show_issue do |object|
    Document::Issue.where(created_by: object.id)&.count
  end
end
