module NotificationManager
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_user_params_change!, only: [:update]
  end

  def show
  end

  def update
    if current_user.update(user_params)
      maybe_send_initial_notification

      redirect_to redirect_path,
                  notice: 'Notification preferences were successfully updated.'
    else
      render :show
    end
  end

  def boolify_param!(params, name)
    unless params[name].nil?
      params[name] = !["0", "", false].include?(params[name])
    end

    params
  end

  def user_params
    filtered_params = params
      .require(:user)
      .permit(:notify_email, :notify_sms, :phone_number)

    boolify_param!(filtered_params, :notify_email)
    boolify_param!(filtered_params, :notify_sms)

    unless filtered_params[:phone_number].nil?
      if filtered_params[:phone_number] == ''
        filtered_params[:phone_number] = nil
      else
        filtered_params[:phone_number].tr!('- ()', '')
      end
    end

    filtered_params
  end

  def maybe_send_initial_notification
    if @user_params_change
      notifier = Notifier::Service.new
      notifier.notify(current_user,
        "You are now receiving notifications from RideBoard.app. " +
        "Change you preferences any time at #{root_notify_url}")
    end
  end

  private
    def set_user_params_change!
      @user_params_change = false
      user_params.each do |key, value|
        if current_user[key] != value
          @user_params_change = true
        end
      end
    end
end

