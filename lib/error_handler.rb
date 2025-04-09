# Error module to Handle errors globally
# include Error::ErrorHandler in application_controller.rb
module ErrorHandler
  logger = Rails.logger

  def self.included(clazz)
    clazz.class_eval do
      rescue_from Exception do |e|
        logger.error "RENDER 500, #{e}"
        logger.error "Rendering 500 with exception: #{e.message}, type: #{e.class},\n Backtrace:\n\t#{e.backtrace.join("\n\t")}" if e
        respond(e.to_s, :method_not_allowed)
      end
      rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
      rescue_from ActiveRecord::RecordNotUnique, with: :respond_duplicate_entry
      rescue_from Pundit::NotAuthorizedError, with: :respond_access_denied
      rescue_from ArgumentError, with: :render_argument_error
    end
  end

  def render_unprocessable_entity_response(exception)
    validation_error_parser(exception.record.errors, :unprocessable_entity)
  end

  def render_not_found_response(exception)
    logger.error "RENDER 500, #{exception.message}"
    render json: { code: 404, message:'Not Found' }, status: :not_found
  end

  def respond_access_denied(_exception)
    respond("You don't have permission", :forbidden)
  end

  def render_argument_error(exception)
    respond(exception.message, :unprocessable_entity)
  end

  def render_auth_validation_error(exception)
    parsed_message = exception.message
    begin
      parsed_message = JSON.parse(parsed_message.gsub('=>', ':'))
    rescue JSON::ParserError
      parsed_message = exception.message
    end
    respond(parsed_message, :unprocessable_entity)
  end

  def respond_duplicate_entry(exception)
    respond(exception.message, :unprocessable_entity)
  end

  def validation_error_parser(_errors, _status)
    errors = []
    _errors.each do |error|
      errors.append({
        field: error.attribute,
        type: error.type,
        message: error.message
      })
    end
    render json: {error: {type: 'fields', errors: errors }}, status: _status
  end

  def action_error_parser(code:, message:, status:)
    render json: {error: {code: code, message: message }}, status: status
  end

  private

  def respond(_message, _status)
    render json: { error: _message }, status: _status
  end
end
