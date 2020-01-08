class WelcomeController < ApplicationController
  def index
  end

  def share
    @ride = Ride.find params[:ride_id]
    unless @ride.driver.nil?
      redirect_to passenger_ride_path(@ride)
    end
  end
end
