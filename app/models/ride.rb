class Ride < ApplicationRecord
  belongs_to :driver,         class_name: "User", optional: true
  belongs_to :created_by,     class_name: "User"
  belongs_to :start_location, class_name: "Location"
  belongs_to :end_location,   class_name: "Location"

  has_many :seat_assignments, dependent: :destroy
  has_many :passengers, through: :seat_assignments, source: :user

  def authorized_editor?(editor)
    driver == editor ||
      (driver.nil? && created_by == editor) ||
      editor.admin?
  end

  def has_passenger?(passenger)
    !passenger.nil? && passengers.exists?(passenger.id)
  end

  validate do |ride|
    unless ride.seats != 0
      ride.errors[:seats] << "cannot have zero seats"
    end

    unless ride.end_datetime.nil? || ride.start_datetime <= ride.end_datetime
      ride.errors[:end_datetime] << "must come after start datetime"
    end
  end
end
