module Notifier
  class NotifierService
    def initialize
      sendReal = ENV['SEND_REAL_MESSAGES'] == 'true'

      # Initialize email, sms, fb, etc
      @sms_notifier = Notifier::SmsNotifier.new(sendReal)
    end
    def send_notification(user, message)
      # Delegate to proper notifier from enum in db...

      # Where this_notifier is the one delegated too
      # this_notifier.send_message(user, message)
      @sms_notifier.send(user, message)
    end
  end
end
