class Passenger::NotificationsController < Passenger::BaseController
  include NotificationManager

  def app
    :passenger
  end

  def root_notify_url
    passenger_notify_url
  end

  def redirect_path
    passenger_me_path
  end
end
