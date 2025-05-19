class V1::UsersController < ApplicationController
  before_action :authorize_request
  before_action :set_user, only: %i[show update destroy]

  def index
    @users = Base::User.all.order(id: :desc)
    render json: V1::UserSerializer.new(@users, params: {show_issue: true})
  end

  def show
    render json: V1::UserSerializer.new(@user)
  end

  def create
    @user = Base::User.new_user(user_params)
    render json: V1::UserSerializer.new(@user)
  end

  def update
    ActiveRecord::Base.transaction do
      @user.update(user_params.except(:password))
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  private

  def set_user
    @user = Base::User.find(params[:id])
  end

  def user_params
    params.permit(:email, :firstname, :lastname, :avatar, :company_id, :role_id, :password)
  end

end
