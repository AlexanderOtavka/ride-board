class Driver::NotificationsController < ApplicationController
  include NotificationManager

  def redirect_path
    driver_ride_path(@ride)
  end
end
