class V1::GlossarySerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :content, :workspace_id, :created_at, :updated_at
end
