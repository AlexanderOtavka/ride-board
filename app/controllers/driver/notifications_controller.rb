class Driver::NotificationsController < Driver::BaseController
  include NotificationManager

  def app
    :driver
  end

  def root_notify_url
    driver_notify_url
  end

  def redirect_path
    driver_me_path
  end
end
