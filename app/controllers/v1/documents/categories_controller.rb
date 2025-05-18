class V1::Documents::CategoriesController < ApplicationController
	before_action :authorize_request
	before_action :set_category, only: %i[show update destroy]

	def index
		@categories = Document::Category.where(workspace_id: params[:workspace_id])
		render json: V1::CategorySerializer.new(@categories)
	end

	def show
		render json: V1::CategorySerializer.new(@category, params: { show_detail: true })
	end

	def create
		@category = Document::Category.new(category_params)
		if @category.save
			render json: V1::CategorySerializer.new(@category), status: :created
		else
			render json: @category.errors, status: :unprocessable_entity
		end
	end

	def update
		if @category.update(category_params)
			render json: V1::CategorySerializer.new(@category)
		else
			render json: @category.errors, status: :unprocessable_entity
		end
	end

	def destroy
		@category.destroy
		head :no_content
	end

	private

	def set_category
		@category = Document::Category.find(params[:id])
	rescue ActiveRecord::RecordNotFound
		render json: { error: 'Category not found' }, status: :not_found
	end

	def category_params
		params.permit(:name, :description, :workspace_id, :parent_id)
	end
end
