module Notifiers
  class NotImplementedError < NoMethodError
  end

  class NotifierBase
    # Initialize should take a 'real_messages' boolean parameter
    # To know whether or not to initialize clients

    def log_message(user, message)
      raise NotImelmentedError
    end

    def real_message(user, message)
      raise NotImelmentedError
    end
  end
end
