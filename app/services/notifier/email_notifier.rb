require 'mailgun-ruby'

module Notifier
  class EmailNotifier < Notifier::Base
    def initialize(real_messages)
      super real_messages
      if real_messages
        @mg_client = Mailgun::Client.new ENV['MAILGUN_API_KEY']
      end
      @logger = Rails.logger
      @from_email = "notifications@#{ENV['MAILGUN_DOMAIN']}"

    end

    def real_message(user, message)
      send_message(user, message, "Someone commented on your post!")
    end

    # user: a user model
    # message: string
    def send_message(user,
                     message,
                     subject,
                     tracking: true,
                     tracking_click: true,
                     tracking_opens: true,
                     tags: "Comment Notifications")
      msg = _build_message_and_log(user, message, subject,
                                   tracking, tracking_click,
                                   tracking_opens, tags)
      @mg_client.send_message ENV['MAILGUN_DOMAIN'], msg
    end

    def log_message(user, message)
      send_log(user, message, "Someone commented on your post!")
    end

    def send_log(user, message, subject)
      msg = _build_message_and_log(user, message, subject,
                                   false, false, false , [])
      @logger.info "Sending #{msg}"
    end

    def _build_message_and_log(user,
                               body,
                               email_subject,
                               tracking=true,
                               tracking_click=true,
                               tracking_opens=true,
                               tags="Comment Notifications") # tags are used to categorize email traffic

      msg = {
          :from => @from_email,
          :to => user,
          :subject => email_subject,
          :text => body,
          "o:tracking" => tracking,
          "o:tracking-click" => tracking_click,
          "o:tracking-opens" => tracking_opens
      }
      if tags != nil
        msg["o:tag"] = tags
      end

      @logger.debug msg
      return msg
    end
  end
end
