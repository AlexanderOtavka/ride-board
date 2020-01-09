class Driver::RideNotificationsController < Driver::BaseController
  include RideNotificationManager

  def app
    :driver
  end

  def root_notify_url
    driver_notify_url
  end

  def redirect_path
    driver_ride_path(@ride)
  end
end
