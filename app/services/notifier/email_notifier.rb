module Notifier
  class EmailNotifier < Base
    def real_message(user, message)
      raise NoMethodError
    end

    def log_message(user, message)
      Rails.logger.info "Sending email '#{message}' to #{user.email}"
    end
  end
end
