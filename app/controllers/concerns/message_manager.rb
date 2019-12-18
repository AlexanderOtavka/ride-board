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
      if @ride.driver == current_user
        @ride.engaged_users.each do |user|
          notifier.notify(user,
            ellipsize(
              "Your driver says: \"",
              message.content,
              "\" See #{share_ride_url(@ride)} for details"
            ))
        end
      elsif @ride.driver == nil
        @ride.engaged_users.each do |user|
          if user != current_user
            notifier.notify(user,
              ellipsize(
                "#{current_user.email} says: \"",
                message.content,
                "\" See #{share_ride_url(@ride)} for details"
              ))
          end
        end
      else
        notifier.notify(@ride.driver,
          ellipsize(
            "Your passenger (#{current_user.email}) says: \"",
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
