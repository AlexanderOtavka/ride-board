module MessageManager
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_ride
  end

  def create
    message = Message.new(message_params.merge(
      ride: @ride,
      created_by: current_user,
    ))

    if message.save
      notifier = Notifier::Service.new
      if current_user == @ride.driver
        @ride.passengers.each do |passenger|
          notifier.send_notification(passenger,
            "Your driver posted a message. " +
            "See #{share_ride_url(@ride)} for details")
        end
      else
        notifier.send_notification(@ride.driver,
          "A message was posted on your ride. " +
          "See #{short_driver_ride_url(@ride)} for details")
      end

      redirect_to ride_path(message.ride), notice: 'Message posted.'
    else
      redirect_to ride_path(message.ride), notice: 'Cannot post message.'
    end
  end

  private
    def set_ride
      @ride = Ride.find(params[:ride_id])
    end

    def message_params
      params.require(:message).permit(:content)
    end
end
