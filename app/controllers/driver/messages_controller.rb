module Driver
  class MessagesController < ApplicationController
    include MessageManager

    def app
      :driver
    end

    def ride_path(ride)
      driver_ride_path(ride)
    end
  end
end
