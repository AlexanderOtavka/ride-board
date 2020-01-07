class Driver::MeController < ApplicationController
  include ProfileManager

  def show
    @upcoming_rides = upcoming_rides current_user.rides_driven
    @past_rides = past_rides current_user.rides_driven
  end
end
