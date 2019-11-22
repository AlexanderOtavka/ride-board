class SeatAssignment < ApplicationRecord
  belongs_to :ride
  belongs_to :user

  validate do |seat_assignment|
    ride = seat_assignment.ride
    unless ride.seats.nil? || ride.passengers.count < ride.seats
      seat_assignment.errors[:ride] << "must have empty seats"
    end

    unless ride.driver != seat_assignment.user
      seat_assignment.errors[:user] << "cannot join if they are the driver"
    end
  end
end
