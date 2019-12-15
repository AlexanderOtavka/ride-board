class Notifier::Service
  def initialize
    send_real = ENV['SEND_REAL_MESSAGES'] == 'true'

    @sms_notifier   = Notifier::SmsNotifier.new(send_real)
    @email_notifier = Notifier::EmailNotifier.new(send_real)
  end

  def send_notification(user, message)
    if user.notify_sms?
      @sms_notifier.send(user, message)
    end

    if user.notify_email?
      @email_notifier.send(user, message)
    end
  end
end
