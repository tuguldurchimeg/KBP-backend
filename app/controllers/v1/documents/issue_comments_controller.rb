class V1::Documents::IssueCommentsController < ApplicationController
  before_action :authorize_request
  before_action :set_issue, only: %i[index create]
  before_action :set_comment, only: %i[show update destroy]

  def index
    @comments = @issue.issue_comments
    render json: V1::IssueCommentSerializer.new(@comments)
  end

  def show
    render json: V1::IssueCommentSerializer.new(@comment)
  end

  def create
    @comment = @issue.issue_comments.new(comment_params)
    if @comment.save
      render json: V1::IssueCommentSerializer.new(@comment), status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      render json: V1::IssueCommentSerializer.new(@comment)
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    head :no_content
  end

  private

  def set_issue
    @issue = Document::Issue.find(params[:issue_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Issue not found' }, status: :not_found
  end

  def set_comment
    @comment = Document::IssueComment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Comment not found' }, status: :not_found
  end

  def comment_params
    params.permit(:comment, :user_id, :issue_id, :parent_id)
  end
end
