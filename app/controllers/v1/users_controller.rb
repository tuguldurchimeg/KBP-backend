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
    @user = Base::User.new(user_params)
    @user.uid = SecureRandom.uuid
    default_password = ENV['DEFAULT_USER_PASSWORD']
    @user.password = default_password
    company = Base::Company.find_by(uid: Current.current_company)
    @user.role = company.roles.first
    @user.company = company

    if @user.save
      render json: V1::UserSerializer.new(@user)
    else
      render json: @user.errors, status: :unprocessable_entity
    end
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
