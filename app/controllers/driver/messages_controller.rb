class Driver::MessagesController < Driver::BaseController
  include MessageManager

  def app
    :driver
  end

  def ride_path(ride, *args)
    driver_ride_path(ride, *args)
  end
end
