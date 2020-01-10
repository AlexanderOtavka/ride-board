# Remove the next line this line when you (yes you) start working on this file
# rubocop:disable all
module Notifier
  class FacebookMessengerNotifier < Base
    # user: a user model
    # message: string
    def log_message(user, message)
      raise NoMethodError
    end

    # user: a user model
    # message: string
    def real_message(user, message)
      raise NoMethodError
    end
  end
end
