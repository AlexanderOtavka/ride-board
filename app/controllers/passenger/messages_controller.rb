class Passenger::MessagesController < Passenger::BaseController
  include MessageManager

  def app
    :passenger
  end

  def ride_path(ride)
    passenger_ride_path(ride)
  end
end
