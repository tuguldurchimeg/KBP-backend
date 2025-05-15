class V1::WorkspacesController < ApplicationController
  before_action :authorize_request
  before_action :set_workspace, only: %i[show update destroy]

  def index
    @workspaces = Base::Workspace.all.order(id: :asc)
    render json: V1::WorkspaceSerializer.new(@workspaces)
  end

  def show
    render json: V1::WorkspaceSerializer.new(@workspace, params: { show_detail: true })
  end

  def create
    @workspace = Base::Workspace.new(workspace_params.merge(creator_id: @current_user.id, company_id: 1))
    ActiveRecord::Base.transaction do
      @workspace.save!
      @workspace.create_workspace_roles(@current_user)
    end
    render json: V1::WorkspaceSerializer.new(@workspace), status: :created
  end

  def update
    if @workspace.update(workspace_params)
      render json: V1::WorkspaceSerializer.new(@workspace)
    else
      render json: @workspace.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @workspace.destroy
    head :no_content
  end

  def search
    query = params[:keyword].to_s.strip.downcase
    workspace_id = params[:workspace_id]

    return render json: { error: 'Missing query' }, status: :bad_request if query.blank?

    documents = Document::Document.where(nil) # starts with a scope chain

    if workspace_id.present?
      documents = documents.where(workspace_id: workspace_id)
    end

    documents = documents.where(
      "LOWER(title) LIKE :query OR EXISTS (
        SELECT 1
        FROM jsonb_path_query_array(documents.content, '$.content[*].content[*].text') AS text_elements(elem)
        WHERE LOWER(elem::text) LIKE :query
      )",
      query: "%#{query}%"
    )

    categories = Document::Category.where('LOWER(name) ILIKE ?', "%#{query}%")
    categories = categories.where(workspace_id: workspace_id) if workspace_id.present?

    files = Document::File.includes(:file_documents).where('LOWER(name) ILIKE ?', "%#{query}%")
    files = files.where(workspace_id: workspace_id) if workspace_id.present?

    render json: {
      documents: V1::DocumentSerializer.new(documents),
      categories: V1::CategorySerializer.new(categories),
      files: V1::FileSerializer.new(files)
    }
  end

  private

  def set_workspace
    @workspace = Base::Workspace.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Workspace not found' }, status: :not_found
  end

  def workspace_params
    params.require(:workspace).permit(:name, :company_id, :description, :image_url)
  end
end
