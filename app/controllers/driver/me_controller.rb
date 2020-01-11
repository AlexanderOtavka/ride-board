class Driver::MeController < Driver::BaseController
  include ProfileManager

  def show
    @upcoming_rides = current_user.rides_driving
    @past_rides     = current_user.rides_driven
  end
end
