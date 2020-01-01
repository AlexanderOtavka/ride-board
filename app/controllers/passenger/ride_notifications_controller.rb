class Passenger::RideNotificationsController < ApplicationController
  include RideNotificationManager

  def app
    :passenger
  end

  def notify_url
    passenger_ride_notify_url(@ride)
  end

  def redirect_path
    passenger_ride_path(@ride)
  end
end
