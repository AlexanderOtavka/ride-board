module ProfileManager
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  def upcoming_rides(query)
    query.where("start_datetime > ?", Time.zone.now)
         .order(:start_datetime)
  end

  def past_rides(query)
    query.where("start_datetime <= ?", Time.zone.now)
         .order(:start_datetime)
  end

end
