class Passenger::RideNotificationsController < ApplicationController
  include RideNotificationManager

  def app
    :passenger
  end

  def root_notify_url
    passenger_notify_url
  end

  def redirect_path
    passenger_ride_path(@ride)
  end
end
