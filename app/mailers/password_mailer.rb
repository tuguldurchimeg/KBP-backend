class PasswordMailer < ApplicationMailer
    def send_password
      @user = params[:user]
      subject = I18n.t('mailer.send_new_password.subject')
      mail(to: @user.email, subject: subject)
    end

    def send_confirmation_code
      @user = params[:user]
      subject = I18n.t('mailer.send_confirmation_code.subject')
      mail(to: @user.email, subject: subject)
    end
end
