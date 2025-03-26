class V1::UsersController < ApplicationController
  before_action :authorize_request
  before_action :set_user, only: %i[show update destroy]

  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  # GET /users/1
  def show
    render json: UserSerializer.new(@user)
  end

  # POST /users
  def create
    @user = User.new(user_params)
    @user.uid = SecureRandom.uuid
    if @user.save
      render json: UserSerializer.new(@user)
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:email, :firstname, :lastname, :status, :avatar, :role_id, :password)
  end

end
