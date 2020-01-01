class Driver::RideNotificationsController < ApplicationController
  include RideNotificationManager

  def app
    :driver
  end

  def notify_url
    driver_ride_notify_url(@ride)
  end

  def redirect_path
    driver_ride_path(@ride)
  end
end
