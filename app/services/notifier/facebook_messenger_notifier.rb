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
