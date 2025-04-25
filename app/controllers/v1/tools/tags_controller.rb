class V1::Tools::TagsController < ApplicationController
  before_action :authorize_request
  before_action :set_tag, only: %i[show update destroy]

  def index
    @tags = Tool::Tag.all
    render json: V1::TagSerializer.new(@tags)
  end

  def show
    render json: V1::TagSerializer.new(@tag)
  end

  def create
    @tag = Tool::Tag.new(tag_params)
    if @tag.save
      render json: V1::TagSerializer.new(@tag), status: :created
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  def update
    if @tag.update(tag_params)
      render json: V1::TagSerializer.new(@tag)
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @tag.destroy
    head :no_content
  end

  private

  def set_tag
    @tag = Tool::Tag.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Tag not found' }, status: :not_found
  end

  def tag_params
    params.require(:tag).permit(:name, :description, :color)
  end
end
