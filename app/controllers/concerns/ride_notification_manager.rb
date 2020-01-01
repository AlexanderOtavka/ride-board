module RideNotificationManager
  extend ActiveSupport::Concern
  include NotificationManager

  included do
    before_action :set_ride
  end

  def show
    @notify_this_ride = notify_this_ride?
  end

  def update
    if current_user.update(user_params)
      maybe_send_initial_notification

      if !ride_params[:notify?].nil? && ride_params[:notify?] != notify_this_ride?
        if ride_params[:notify?]
          @ride.notification_subscriptions.create!(user: current_user, app: app)
        else
          @ride.notification_subscribers.delete current_user
        end
      end

      redirect_to redirect_path,
                  notice: 'Notification preferences were successfully updated.'
    else
      render :show
    end
  end

  private
    def set_ride
      @ride = Ride.find(params[:ride_id])
    end

    def notify_this_ride?
      @ride.notification_subscribers.include? current_user
    end

    def ride_params
      filtered_params = params.require(:ride).permit(:notify)

      unless filtered_params[:notify].nil?
        filtered_params[:notify?] = !["0", "", false].include?(filtered_params[:notify])
      end

      filtered_params
    end
end
