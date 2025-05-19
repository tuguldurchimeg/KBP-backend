class ApplicationMailer < ActionMailer::Base
  # default from: "info@#{ENV['MAIL_DOMAIN']}"
  default from: ENV['EMAIL']
  layout 'mailer'
end
