module NotificationManager
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_ride
  end

  def show
  end

  private
    def set_ride
      @ride = Ride.find(params[:ride_id])
    end

    def notify_params
      filtered_params = params
        .require(:user)
        .permit(:notify_email, :notify_sms, :phone_number)

      if !filtered_params[:phone_number].nil?
        if filtered_params[:phone_number] == ''
          filtered_params[:phone_number] = nil
        else
          filtered_params[:phone_number].tr!('- ()', '')
        end
      end

      filtered_params
    end
end
