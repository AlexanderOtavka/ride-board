module RideManager
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, except: [:index, :show]
    before_action :set_ride, only: [:show, :join, :leave, :edit, :update,
                                    :destroy]
    before_action :authorize_user!, only: [:edit, :update, :destroy]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ride_params(permit: [])
    params.require(:ride)
      .permit(
        :start_location_id,
        :start_datetime,
        :end_location_id,
        :end_datetime,
        :price,
        *permit
      )
  end

  private

    def set_ride
      @ride = Ride.find(params[:id])
    end

    def authorize_user!
      unless @ride.authorized_editor? current_user
        render_unauthorized
      end
    end

end
