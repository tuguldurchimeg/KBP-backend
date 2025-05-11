class V1::Documents::IssuesController < ApplicationController
  before_action :authorize_request
  before_action :set_issue, only: %i[show update destroy]

  def index
    @issues = Document::Issue.where(workspace_id: params[:workspace_id])
    render json: V1::IssueSerializer.new(@issues)
  end

  def show
    render json: V1::IssueSerializer.new(@issue, params: {show_detail: true})
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
      render json: @issue.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @issue.destroy
    head :no_content
  end

  def report
      issues = Document::Issue.where(workspace_id: params[:workspace_id])
      by_status = issues.group(:status).count.map do |status, count|
        { status: status, count: count }
      end

      by_priority = issues.group(:priority).count.map do |priority, count|
        { priority: priority, count: count }
      end

      by_type = issues.group(:issue_type).count.map do |issue_type, count|
        { type: issue_type, count: count }
      end

      by_issue_assignee = issues.joins(:issue_assignees)
                                 .group('issue_assignees.user_id')
                                 .count.map do |user_id, count|
        user = Base::User.find_by(id: user_id)
        { user: V1::UserSerializer.new(user), count: count }
      end

      render json: {
        by_status: by_status,
        by_priority: by_priority,
        by_type: by_type,
        by_issue_assignee: by_issue_assignee
      }
  end

  def assign
    @issueAssignee = Document::IssueAssignee.new(user_id: params[:user_id], issue_id: params[:issue_id])
    if @issueAssignee.save
      render json: V1::IssueAssigneeSerializer.new(@issueAssignee), status: :ok
    else
      render json: @issueAssignee.errors, status: :unprocessable_entity
    end
  end

  private

  def set_issue
    @issue = Document::Issue.find(params[:id])
  end

  def issue_params
    params.permit(:title, :description, :status, :priority, :issue_type, :workspace_id)
  end
end
