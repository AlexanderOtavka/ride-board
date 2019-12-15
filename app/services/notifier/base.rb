class Notifier::Base
  # Initialize should take a 'real_messages' boolean parameter
  # To know whether or not to initialize clients
  def initialize(send_real_messages)
    @send_real_messages = send_real_messages
  end

  # Subclasses should implement real_message and log_message
  def send(user, message)
    if @send_real_messages
      real_message(user, message)
    else
      log_message(user, message)
    end
  end
end
