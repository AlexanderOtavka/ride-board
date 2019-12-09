module Notifiers
  class Notifier
    def initialize
      # Initialize email, sms, fb, etc
    end
    def send_notification(user, message)
      # Delegate to proper notifier from enum in db...

      # Where this_notifier is the one delegated too
      if ENV['SEND_REAL_MESSAGES'] == 'true'
        this_notifier.real_message(user, message)
      else
        this_notifier.log_message(user, message)
      end
    end
  end
end
