class Ride < ApplicationRecord
  belongs_to :driver, class_name: "User"
  belongs_to :start_location, class_name: "Location"
  belongs_to :end_location, class_name: "Location"

  validate do |ride|
    unless ride.end_datetime.nil? || ride.start_datetime <= ride.end_datetime
      ride.errors[:end_datetime] << "must come after start datetime"
    end
  end
end
