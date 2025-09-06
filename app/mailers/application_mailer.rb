class ApplicationMailer < ActionMailer::Base
  default from: ENV["MAIL_USER_NAME"]
  layout 'mailer'
end
