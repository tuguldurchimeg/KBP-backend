class V1::CompaniesController < ApplicationController
  before_action :authorize_request
  before_action :set_company, only: %i[show update destroy]

  def index
    @companies = Company.all
    render json: @companies
  end

  def show
    render json: @company
  end

  def create
    @company = Company.new(company_params.merge(uid: SecureRandom.uuid))
    if @company.save
      render json: @company, status: :created
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  def update
    if @company.update(company_params)
      render json: @company
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @company.destroy
    head :no_content
  end

  private

  def set_company
    @company = Company.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Company not found' }, status: :not_found
  end

  def company_params
    params.require(:company).permit(:name, :address, :phone, :email)
  end
end
