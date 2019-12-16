class Notifier::Service
  def initialize
    @send_real_messages = ENV['SEND_REAL_MESSAGES'] == 'true'
  end

  def notify_sms(user, message)
    if user.notify_sms?
      @sms_notifier ||= Notifier::SmsNotifier.new(@send_real_messages)
      @sms_notifier.notify(user, message)
    end
  end

  def notify_email(user, message)
    if user.notify_email?
      @email_notifier ||= Notifier::EmailNotifier.new(@send_real_messages)
      @email_notifier.notify(user, message)
    end
  end

  def notify(user, message)
    notify_sms(user, message)
    notify_email(user, message)
  end
end
