module Passenger
  class MessagesController < ApplicationController
    include MessageManager

    def ride_path(ride)
      passenger_ride_path(ride)
    end
  end
end
