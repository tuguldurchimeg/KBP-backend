class V1::UsersController < ApplicationController
  before_action :authorize_request
  before_action :set_user, only: %i[show update destroy]

  def index
    @users = Base::User.all
    render json: @users
  end

  def show
    render json: V1::UserSerializer.new(@user)
  end

  def create
    @user = Base::User.new(user_params)
    @user.uid = SecureRandom.uuid
    if @user.save
      # render json: V1::UserSerializer.new(@user)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    ActiveRecord::Base.transaction do
      @user.update(user_params.except(:password))
    end
  end

  private

  def set_user
    @user = Base::User.find(params[:id])
  end

  def user_params
    params.permit(:email, :firstname, :lastname, :avatar, :company_id, :role_id, :password)
  end

end
