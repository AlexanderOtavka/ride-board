module Notifier
  class NotImplementedError < NoMethodError
  end

  class NotifierBase
    # Initialize should take a 'real_messages' boolean parameter
    # To know whether or not to initialize clients
    def initialize(send_real_messages)
      @send_real_messages = send_real_messages
    end

    def send(user, message)
      if @send_real_messages
        real_message(user, message)
      else
        log_message(user, message)
      end
    end

    def log_message(user, message)
      raise NotImelmentedError
    end

    def real_message(user, message)
      raise NotImelmentedError
    end
  end
end
