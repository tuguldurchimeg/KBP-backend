class V1::Documents::FilesController < ApplicationController
  before_action :authorize_request
  before_action :set_file, only: %i[show destroy]

  def index
    @files = Document::File.where(workspace_id: params[:workspace_id])
    render json: V1::FileSerializer.new(@files)
  end

  def show
    render json: V1::FileSerializer.new(@file)
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
    params.permit(:name, :content, :document_id, :workspace_id)
  end
end
