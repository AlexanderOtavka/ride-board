class Passenger::MessagesController < Passenger::BaseController
  include MessageManager

  def app
    :passenger
  end

  def ride_path(ride, *args)
    passenger_ride_path(ride, *args)
  end
end
