class V1::Documents::IssuesController < ApplicationController
  before_action :authorize_request
  before_action :set_issue, only: %i[show update destroy]

  def index
    @issues = Document::Issue.all
    render json: V1::IssueSerializer.new(@issues)
  end

  def show
    render json: V1::IssueSerializer.new(@issue)
  end

  def create
    @issue = Document::Issue.new(issue_params.merge(created_by: @current_user.id))
    if @issue.save
      render json: V1::IssueSerializer.new(@issue), status: :created
    else
      render json: @issue.errors, status: :unprocessable_entity
    end
  end

  def update
    if @issue.update(issue_params)
      render json: V1::IssueSerializer.new(@issue)
    else
      render json: issue.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @issue.destroy
    head :no_content
  end

  def assign
    @issueAssignee = Document::IssueAssignee.new(user_id: params[:user_id], issue_id: params[:issue_id])
    if @issueAssignee.save
      render json: { message: 'Document successfully assigned to issue.' }, status: :ok
    else
      render json: { error: 'Failed to assign document to issue.' }, status: :unprocessable_entity
    end
  end

  private

  def set_issue
    @issue = Document::Issue.find(params[:id])
  end

  def issue_params
    params.require(:issue).permit(:title, :description, :status, :priority)
  end
end
