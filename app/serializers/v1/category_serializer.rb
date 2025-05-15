class V1::CategorySerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :parent_id

  show_detail = proc do |record, params|
    params[:show_detail]
  end

  attribute :subcategories, if: show_detail do |object, params|
    subs = Document::Category.where(parent_id: object.id)
    V1::CategorySerializer.new(subs, params: { show_detail: true, tag_ids: params[:tag_isd] })
  end

  attribute :documents, if: show_detail do |object, params|
    docs = object.documents.where(is_template: false)
    docs = docs.left_joins(:tag_documents).where(tag_documents: { tag_id: params[:tag_ids]}).uniq if params[:tag_ids].present?
    V1::DocumentSerializer.new(docs)
  end
end
