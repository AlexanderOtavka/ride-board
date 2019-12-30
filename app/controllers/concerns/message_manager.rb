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
      if @ride.driver == nil || @ride.driver == current_user
        if @ride.driver == current_user
          sender = "Your driver"
        else
          sender = current_user.email
        end

        subscribers = @ride.notification_subscribers.where.not(
          id: current_user.id)
        drivers = @ride.notification_subscribers.where(
          ride_notification_subscriptions: {app: :driver})
        passengers = @ride.notification_subscribers.where(
          ride_notification_subscriptions: {app: :passenger})

        drivers.each do |driver|
          notifier.notify(driver,
            ellipsize("#{sender} says: \"", message.content,
                      "\" See #{short_driver_ride_url(@ride)} for details"))
        end

        passengers.each do |passenger|
          notifier.notify(passenger,
            ellipsize("#{sender} says: \"", message.content,
                      "\" See #{share_ride_url(@ride)} for details"))
        end
      else
        if @ride.passengers.include? current_user
          sender = "Your passenger"
        else
          sender = current_user.email
        end

        notifier.notify(@ride.driver,
          ellipsize(
            "#{sender} says: \"",
            message.content,
            "\" See #{short_driver_ride_url(@ride)} for details"
          ))
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

    def ellipsize(prefix, long_text, suffix, max_length: 160)
      length = prefix.length + long_text.length + suffix.length
      if length > max_length
        target_length = max_length - prefix.length - suffix.length - '...'.length
        long_text = long_text[0..target_length] + '...'
      end

      prefix + long_text + suffix
    end
end
