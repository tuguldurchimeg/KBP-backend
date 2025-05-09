class V1::Tools::GlossariesController < ApplicationController
  before_action :authorize_request
  before_action :set_glossary, only: %i[show update destroy]

  def index
    glossaries = Tool::Glossary.where(workspace_id: params[:workspace_id])
    render json: V1::GlossarySerializer.new(glossaries)
  end

  def show
    render json: V1::GlossarySerializer.new(@glossary)
  end

  def create
    @glossary = Tool::Glossary.new(glossary_params)
    if @glossary.save
      render json: V1::GlossarySerializer.new(@glossary), status: :created
    else
      render json: @glossary.errors, status: :unprocessable_entity
    end
  end

  def update
    if @glossary.update(glossary_params)
      render json: V1::GlossarySerializer.new(@glossary)
    else
      render json: @glossary.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @glossary.destroy
    head :no_content
  end

  private

  def set_glossary
    @glossary = Tool::Glossary.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Glossary not found' }, status: :not_found
  end

  def glossary_params
    params.require(:glossary).permit(:name, :content, :workspace_id)
  end
end
