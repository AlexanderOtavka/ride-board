class Passenger::NotificationsController < ApplicationController
  include NotificationManager

  def app
    :passenger
  end

  def root_notify_url
    passenger_notify_url
  end

  def redirect_path
    passenger_rides_path
  end
end
