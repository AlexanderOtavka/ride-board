class Driver::MessagesController < Driver::BaseController
  include MessageManager

  def ride_path(ride)
    driver_ride_path(ride)
  end
end
