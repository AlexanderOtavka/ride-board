class Passenger::MeController < Passenger::BaseController
  include ProfileManager

  def show
    @upcoming_rides = current_user.rides_taking
    @past_rides     = current_user.rides_taken
  end
end
