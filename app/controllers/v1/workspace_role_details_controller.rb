class V1::WorkspaceRoleDetailsController < ApplicationController
  before_action :authorize_request
  before_action :set_workspace, only: %i[index]

  def index
    @workspace_roles = @workspace.workspace_role_details.all.order(id: :asc)
    render json: V1::WorkspaceRoleDetailSerializer.new(@workspace_roles)
  end

  def update
    @workspace_role = Base::WorkspaceRoleDetail.find_by(id: params[:id])
    if @workspace_role&.update(action: role_params[:action])
      render json: V1::WorkspaceRoleDetailSerializer.new(@workspace_role)
    else
      render json: @workspace_role.errors, status: :unprocessable_entity
    end
  end

  private

  def set_workspace
    @workspace = Base::Workspace.find(params[:workspace_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Workspace not found' }, status: :not_found
  end

  def role_params
    params.require(:workspace_role_detail).permit(:action, :user_id, :workspace_id)
  end
end
