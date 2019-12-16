class ApplicationMailer < ActionMailer::Base
  default from: "ride-board@#{EVN['MAILGUN_DOMAIN']}"
  layout 'mailer'
end
