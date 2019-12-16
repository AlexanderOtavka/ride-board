class Passenger::NotificationsController < ApplicationController
  include NotificationManager

  def notify_url
    passenger_ride_notify_url(@ride)
  end

  def redirect_path
    passenger_ride_path(@ride)
  end
end
