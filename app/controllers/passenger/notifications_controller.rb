class Passenger::NotificationsController < ApplicationController
  include NotificationManager

  def update
    if current_user.update(notify_params)
      redirect_to passenger_ride_path(@ride),
                  notice: 'Notification preferences were successfully updated.'
    else
      render :show
    end
  end
end
