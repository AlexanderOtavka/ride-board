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
      send_notification(message)

      unless @ride.notification_subscribers.include? current_user
        @ride.notification_subscriptions.create!(user: current_user, app: app)
      end

      redirect_to ride_path(@ride, anchor: 'latest-message')
    else
      redirect_to ride_path(@ride, anchor: 'latest-message'),
                  notice: 'Cannot post message.'
    end
  end

  private
    def set_ride
      @ride = Ride.find(params[:ride_id])
    end

    def message_params
      params.require(:message).permit(:content)
    end

    def send_notification(message)
      ride = message.ride

      notifier = Notifier::Service.new

      subscribers = ride.notification_subscribers.where.not(
        id: message.created_by.id)
      drivers = subscribers.where(
        ride_notification_subscriptions: {app: :driver})
      passengers = subscribers.where(
        ride_notification_subscriptions: {app: :passenger})

      if ride.driver == nil || message.created_by == ride.driver
        if message.created_by == ride.driver
          sender = "Your driver"
        else
          sender = message.created_by.email
        end

        drivers.each do |driver|
          notifier.notify(driver,
            ellipsize("#{sender} says: \"", message.content,
                      "\" See #{short_driver_ride_url(ride)} for details"))
        end

        passengers.each do |passenger|
          notifier.notify(passenger,
            ellipsize("#{sender} says: \"", message.content,
                      "\" See #{share_ride_url(ride)} for details"))
        end
      else
        drivers.each do |driver|
          if driver == ride.driver &&
             ride.passengers.include?(message.created_by)

            sender = "Your passenger"
          else
            sender = message.created_by.email
          end

          notifier.notify(driver,
            ellipsize(
              "#{sender} says: \"",
              message.content,
              "\" See #{short_driver_ride_url(ride)} for details"
            ))
        end
      end
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
