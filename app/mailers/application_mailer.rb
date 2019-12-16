class ApplicationMailer < ActionMailer::Base
  default from: "ride-board@#{ENV['MAILGUN_DOMAIN']}"
  layout 'mailer'
end
