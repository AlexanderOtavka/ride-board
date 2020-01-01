module RideNotificationManager
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_ride
  end

  def show
    @notify_this_ride = notify_this_ride?
  end

  def update
    if current_user.update(user_params)
      notifier = Notifier::Service.new
      notifier.notify(current_user,
        "You are now receiving notifications from RideBoard.app. " +
        "Change you preferences any time at #{notify_url}")

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

    def user_params
      filtered_params = params
        .require(:user)
        .permit(:notify_email, :notify_sms, :phone_number)

      unless filtered_params[:phone_number].nil?
        if filtered_params[:phone_number] == ''
          filtered_params[:phone_number] = nil
        else
          filtered_params[:phone_number].tr!('- ()', '')
        end
      end

      filtered_params
    end
end
