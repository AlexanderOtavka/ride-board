require 'mailgun-ruby'

module Notifier
  class EmailNotifier < NotifierBase
    def initializer(real_messages)
      super(real_messages)
      if real_messages
        @mg_client = Mailgun::Client.new 'api-key'
      end
      @logger = Rails.logger
    end
    # user: a user model
    # message: string
    def send_notification(user, message)

    end
    def _build_message(from_email, to_email, email_subject, body)
      return {
          from: from_email,
          to: to_email,
          subject: email_subject,
          text: body
      }
    end
  end
end
