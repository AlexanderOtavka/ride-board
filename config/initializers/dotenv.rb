Dotenv.require_keys('SEND_REAL_MESSAGES')
ENV['SEND_REAL_MESSAGES'] = ENV['SEND_REAL_MESSAGES'].downcase

if ENV['SEND_REAL_MESSAGES'] == "true"
  Dotenv.require_keys('AWS_ACCESS_KEY_ID', 'AWS_SECRET_ACCESS_KEY', 'AWS_REGION','MAILGUN_API_KEY', 'MAILGUN_DOMAIN', 'TWILIO_ACCOUNT_SID', 'TWILIO_AUTH_TOKEN', 'TWILIO_PHONE_NUMBER')
end
