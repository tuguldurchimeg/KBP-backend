class V1::CategorySerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :parent_id

  show_detail = proc do |record, params|
    params[:show_detail]
  end

  attribute :subcategories, if: show_detail do |object|
    subs = Document::Category.where(parent_id: object.id)
    V1::CategorySerializer.new(subs, params: { show_detail: true })
  end

  attribute :documents, if: show_detail do |object|
    V1::DocumentSerializer.new(object.documents.where(is_template: false))
  end
end
