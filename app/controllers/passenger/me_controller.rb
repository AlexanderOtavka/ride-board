class Passenger::MeController < ApplicationController
  include ProfileManager

  def show
    @upcoming_rides = upcoming_rides current_user.rides_taken
    @past_rides = past_rides current_user.rides_taken
  end
end
