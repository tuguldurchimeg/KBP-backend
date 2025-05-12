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
    if @workspace.save
      render json: V1::WorkspaceSerializer.new(@workspace), status: :created
    else
      render json: @workspace.errors, status: :unprocessable_entity
    end
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
