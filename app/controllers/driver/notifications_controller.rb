class Driver::NotificationsController < ApplicationController
  include NotificationManager

  def notify_url
    driver_ride_notify_url(@ride)
  end

  def redirect_path
    driver_ride_path(@ride)
  end
end
