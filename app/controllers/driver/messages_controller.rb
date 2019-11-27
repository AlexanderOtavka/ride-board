module Driver
  class MessagesController < ApplicationController
    include MessageManager

    def ride_path(ride)
      driver_ride_path(ride)
    end
  end
end
