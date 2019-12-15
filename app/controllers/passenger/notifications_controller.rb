class Passenger::NotificationsController < ApplicationController
  include NotificationManager

  def redirect_path
    passenger_ride_path(@ride)
  end
end
