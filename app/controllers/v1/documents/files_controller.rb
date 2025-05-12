class V1::Documents::FilesController < ApplicationController
  before_action :authorize_request
  before_action :set_file, only: %i[destroy]

  def index
    @files = Document::File.where(workspace_id: params[:workspace_id])
    render json: V1::FileSerializer.new(@files)
  end

  def create
    @file = Document::File.new(file_params.merge(user_id: @current_user.id))
    if @file.save
      render json: @file
    else
      render json: @file.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @file.destroy
    head :no_content
  end

  private

  def set_file
    @file = Document::File.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'File not found' }, status: :not_found
  end

  def file_params
    params.permit(:name, :url, :size, :file_type, :workspace_id)
  end
end
