module MessageManager
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  def create
    message = Message.new(message_params.merge(
      ride_id: params.require(:ride_id),
      created_by: current_user,
    ))

    if message.save
      redirect_to ride_path(message.ride), notice: 'Message posted.'
    else
      redirect_to ride_path(message.ride), notice: 'Cannot post message.'
    end
  end

  private

    def message_params
      params.require(:message).permit(:content)
    end

end
