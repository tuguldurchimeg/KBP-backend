class V1::Documents::IssuesController < ApplicationController
  before_action :authorize_request
  before_action :set_issue, only: %i[show update destroy]

  def index
    @issues = Document::Issue.all
    render json: @issues
  end

  def show
    render json: @issue
  end

  def create
    @issue = Document::Issue.new(issue_params)
    if @issue.save
      render json: @issue, status: :created
    else
      render json: @issue.errors, status: :unprocessable_entity
    end
  end

  def update
    if issue.update(issue_params)
      render json: issue
    else
      render json: issue.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @issue.destroy
    head :no_content
  end

  private

  def set_issue
    @issue = Document::Issue.find(params[:id])
  end

  def issue_params
    params.require(:issue).permit(:title, :description, :status)
  end
end
