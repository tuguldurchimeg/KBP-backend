class V1::Documents::DocumentsController < ApplicationController
  before_action :authorize_request
  before_action :set_document, only: %i[show update destroy]

  def index
    if params[:is_template].present? && params[:is_template]
      @documents = Document::Document.where(is_template: true, workspace_id: params[:workspace_id])
    else
      @documents = Document::Document.where(is_template: false)
    end
    render json: V1::DocumentSerializer.new(@documents)
  end

  def show
    @document.update(view_count: @document.view_count + 1)
    render json: V1::DocumentSerializer.new(@document, params: { show_detail: true })
  end

  def create
    @document = Document::Document.new(document_params.merge(user_id: @current_user.id))
    if @document.save
      render json: V1::DocumentSerializer.new(@document), status: :created
    else
      render json: @document.errors, status: :unprocessable_entity
    end
  end

  def update
    if @document.update(document_params.merge(updated_at: DateTime.current))
      render json: V1::DocumentSerializer.new(@document)
    else
      render json: @document.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @document.destroy
    head :no_content
  end

  def quick_access
    @documents = Document::Document.where(is_template: false).order(view_count: :desc)
    render json: V1::DocumentSerializer.new(@documents)
  end

  def set_document_tag
    @tag_doc = Tool::TagDocument.new(tag_doc_params)
    if @tag_doc.save
      render json: V1::DocumentSerializer.new(@tag_doc.document)
    else
      render json: @tag_doc.errors, status: :unprocessable_entity
    end
  end

  private

  def set_document
    @document = Document::Document.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Document not found' }, status: :not_found
  end

  def document_params
    params.permit(:title, :is_template, :category_id, :workspace_id, content: {} )
  end

  def tag_doc_params
    params.permit(:document_id, :tag_id)
  end
end
