class V1::IssueCommentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :comment, :created_at, :updated_at

  attribute :user do |object|
    V1::UserSerializer.new(object.user)
  end

  attribute :issue do |object|
    V1::IssueSerializer.new(object.issue)
  end

  attribute :replies do |object|
    replies = Document::IssueComment.where(parent_id: object.id)
    V1::IssueCommentSerializer.new(replies)
  end
end
