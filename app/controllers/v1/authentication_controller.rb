class V1::AuthenticationController < ApplicationController
  before_action :authorize_request, only: %i[logout password_change show]

  def social_login
    user_data = SocialAuthentication.google_authentication(params[:access_token])
    if user_data.nil? || !user_data[:email].present?
      return render json: { error: 'Google login failed' },
                    status: :unauthorized
    end
    user = Base::User.unscoped.find_by!(email: user_data[:email])
    # return render json: { error: 'Google login failed' }, status: :unauthorized if user.nil?
    user.update_login_count()
    render json: JsonWebToken.get_tokens({ email: user.email }).to_json, status: :ok
  end

  def login
    if params[:email].nil? || params[:password].nil?
      return render json: { error: 'Missing params' },
                    status: :unauthorized
    end

    user = Base::User.unscoped.authenticated_user(params)
    if user
      render json: JsonWebToken.get_tokens({ email: user.email }).to_json, status: :ok
    else
      render json: { error: 'Unregistered email address' }, status: :unauthorized
    end
  end

  def show
    render json: V1::UserSerializer.new(@current_user)
  end

  def forgot_password
    user = Base::User.confirmation_code_sent(params)
    if user
      PasswordMailer.with(user: user).send_confirmation_code.deliver_now
      render json: { success: 'Success' }, status: :ok
    else
      render json: { error: 'Unregistered email address' }, status: :unprocessable_entity
    end
  end

  def reset
    @user = Base::User.unscoped.find_by_email(params[:email]&.downcase)
    puts "userr: #{@user.inspect}"
    return render json: { error: 'Unregistered email address' }, status: :unauthorized unless @user.present?
    return render json: { error: 'Confirmation code expired' }, status: :unauthorized unless @user.password_code_valid?
    puts "checkk: #{params[:confirmation_code].eql? @user.confirmation_code}"
    puts "params/confirm: #{params[:confirmation_code]}, user/confirm: #{@user.confirmation_code}"
    unless params[:confirmation_code].eql? @user.confirmation_code
      return render json: { error: 'Confirmation code not match' }, status: :unauthorized
    end

    if params[:new_password] == params[:confirm_new_password]
      if @user.authenticate(params[:new_password])
        return render json: {code: 40044, message: I18n.t('errors.messages.used_before') }, status: :unauthorized
      end

      begin
        @user.reset_password!(params[:new_password])
        # UserMailer.reset_password_complete(@user).deliver_now!
        render json: { success: 'password has been reset successfully' }, status: :ok
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Password confirm not match' }, status: :unprocessable_entity
    end
  end

  def refresh_token
    decoded = JsonWebToken.decode_refresh_token(params[:refresh_token]&.strip)
    user = Base::User.unscoped.find_by(email: decoded[:email])
    if decoded[:token_at].present?
      jwt_blacklist = JwtBlacklist.where(user_id: user.id, token_at: decoded[:token_at]).last
      return render json: { error: 'Invalid token' }, status: :unauthorized if jwt_blacklist.present?
    end
    user.increment!(:login_count) if user.login_count <= 1
    render json: JsonWebToken.get_tokens({ email: user.email }).to_json, status: :ok
  rescue JWT::ExpiredSignature=>e
    render json: { error: 'Token expired' }, status: :unauthorized
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    render json: { error: 'Invalid token' }, status: :unauthorized
  end

  def logout
    header = request.headers['authorization']
    if header.present?
      header = header.split(' ').last
      @decoded = JsonWebToken.decode(header)
      JwtBlacklist.add(@current_user.id, header, @decoded)
    end
    render json: { status: 'ok' }, status: :ok
  end

  def signup
    required_params = %i[firstname lastname email company password password_confirm]
    if required_params.any? { |key| params[key].blank? }
      return render json: { error: 'Missing required fields' }, status: :unprocessable_entity
    end

    return render json: { error: 'Passwords do not match' }, status: :unprocessable_entity unless params[:password] == params[:password_confirm]

    if Base::User.unscoped.exists?(email: params[:email].downcase)
      return render json: { error: 'Email already registered' }, status: :unprocessable_entity
    end

    company = Base::Company.find_or_create_by!(name: params[:company]) do |c|
      c.uid = SecureRandom.uuid
    end
    role = company.roles.create!(name: 'Owner')

    user = Base::User.unscoped.new(
      firstname: params[:firstname],
      lastname: params[:lastname],
      email: params[:email].downcase,
      company: company,
      password: params[:password],
      role: role,
      uid: SecureRandom.uuid
    )

    if user.save
      render json: { success: 'User registered successfully', email: user.email }
    else
      render json: { error: user.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def password_change
    if @current_user&.password_digest.present? && @current_user.authenticate(params[:current_password])
      if params[:new_password] == params[:confirm_new_password]
        if @current_user.authenticate(params[:new_password])
          return render json: {code: 40044, message: I18n.t('errors.messages.used_before') }, status: :unauthorized
        end

        if @current_user.update!(password: params[:new_password], password_change_required: false)
          render json: { success: 'Password successfully changed' }, status: :ok
        end
      else
        render json: { code: 40034, message: I18n.t(:confirm_mismatch) }, status: :unprocessable_entity
      end
    else
      render json: { code: 40035, message: I18n.t(:incorrect) }, status: :unprocessable_entity
    end
  end

  def resend_code
    user = Base::User.unscoped.find_by_email(params[:email].downcase)
    if user
      PasswordMailer.with(
        user: user
      ).send_confirmation_code.deliver_now
      render json: { success: 'Success' }, status: :ok
    else
      render json: { error: 'Unregistered email address' }, status: :unprocessable_entity
    end
  end
end
