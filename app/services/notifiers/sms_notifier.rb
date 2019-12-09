require 'aws-sdk-sns'
logger = Rails.logger

module Notifiers
  class SMSNotifier
    def initialize(real_messages)
      if real_messages
        @sns = Aws::SNS::Client.new(
          access_key_id: ENV['']
        )
      end
    end

    # user: a user model
    # message: string
    def send_notification(user, message)
    end
  end
end
