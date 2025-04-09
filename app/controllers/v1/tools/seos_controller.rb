class V1::Tools::SeosController < ApplicationController
  before_action :authorize_request
  before_action :set_seo, only: %i[show update destroy]

  def index
    @seos = Tool::Seo.all
    render json: @seos
  end

  def show
    render json: @seo
  end

  def create
    @seo = Tool::Seo.new(seo_params)
    if @seo.save
      render json: @seo, status: :created
    else
      render json: @seo.errors, status: :unprocessable_entity
    end
  end

  def update
    if @seo.update(seo_params)
      render json: @seo
    else
      render json: @seo.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @seo.destroy
    head :no_content
  end

  private

  def set_seo
    @seo = Tool::Seo.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'SEO not found' }, status: :not_found
  end

  def seo_params
    params.require(:seo).permit(:title, :description, :keywords)
  end
end
