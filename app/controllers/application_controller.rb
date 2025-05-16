class ApplicationController < ActionController::API
  # include ErrorHandler
  # include Pundit::Authorization
  def authorize_request
    auth_header = request.headers['authorization']
    @timezone = request.headers['Time-Zone'].present? ? request.headers['Time-Zone'] : UTC_TIMEZONE
    token = auth_header.split(' ').last
    @decoded = JsonWebToken.decode(token)
    current_company
    @current_user = Base::User.unscoped.find_by(email: @decoded[:email])
  rescue JWT::ExpiredSignature
    render json: { error: 'Token expired' }, status: :unauthorized
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    render json: { error: 'Invalid token' }, status: :unauthorized
  rescue StandardError => e
    auth_logger = Rails.logger
    auth_logger.error '***************************************************'
    auth_logger.error '----- Auth LOG BEGIN -------'
    auth_logger.error "----- Authorization #{request.headers['authorization']}"
    auth_logger.error "----- Error during processing: #{e.message}"
    auth_logger.error "----- Backtrace:\n\t#{e.backtrace.join("\n\t")}"
    auth_logger.error '----- Auth LOG END -------'
    auth_logger.error '***************************************************'
    render json: { error: 'Invalid token' }, status: :unauthorized
  end

  attr_reader :current_user

  def current_company
    user = Base::User.unscoped.where(email: @decoded[:email]).first
    Current.current_company = user.company.uid
  end

  def paginate(scope)
    Paginator.paginate(scope, params)
  end

  def welcome
    render json: { message: 'Welcome' }, status: :ok
  end
end
