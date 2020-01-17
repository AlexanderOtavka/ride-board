class Ride < ApplicationRecord
  belongs_to :driver,         class_name: "User", optional: true
  belongs_to :created_by,     class_name: "User"
  belongs_to :start_location, class_name: "Location"
  belongs_to :end_location,   class_name: "Location"

  has_many :seat_assignments, dependent: :destroy
  has_many :passengers, through: :seat_assignments, source: :user

  has_many :notification_subscriptions, class_name: "RideNotificationSubscription",
                                        dependent: :destroy
  has_many :notification_subscribers, through: :notification_subscriptions,
                                      source: :user

  has_many :messages, dependent: :destroy

  def self.list(query)
    query
      .where("
        rides.driver_id IS NOT NULL OR
        EXISTS (
          SELECT * FROM seat_assignments
          WHERE seat_assignments.ride_id = rides.id
        )
      ")
      .order(:start_datetime, price: :desc)
  end

  def self.upcoming(query = all)
    list(query).where("start_datetime > ?", Time.zone.now)
  end

  def self.past(query = all)
    list(query).where("start_datetime <= ?", Time.zone.now)
  end

  def self.search(query, search)
    search ||= {location: nil, date: nil}

    unless search[:location].nil?
      matches_start_location = query.where(start_location: search[:location])
      matches_end_location = query.where(end_location: search[:location])
      query = matches_start_location.or(matches_end_location)
    end

    unless search[:date].nil?
      query = query.where(
        "start_datetime BETWEEN ? AND ?",
        search[:date].beginning_of_day,
        search[:date].end_of_day,
      )
    end

    query
  end

  def self.available_for_passenger(current_user:, search:)
    self.search(upcoming, search)
      .where.not(driver: nil)
      .where.not(driver: current_user)
      .includes(:passengers)
      .filter {|ride| ride.seats.nil? || ride.seats > ride.passengers.count}
      .filter {|ride| !ride.passengers.include?(current_user)}
      # Possible N+1 performance issue
  end

  def self.driverless(current_user:, search:)
    self.search(upcoming, search)
      .where(driver: nil)
      .includes(:passengers)
      .filter {|ride| !ride.passengers.include?(current_user)}
  end

  def notified_passengers
    User.joins(:seat_assignments, :ride_notification_subscriptions)
      .where("seat_assignments.ride_id = ride_notification_subscriptions.ride_id")
      .where(seat_assignments: {ride_id: id})
  end

  def authorized_editor?(editor)
    !editor.nil? && (
      driver == editor ||
      (driver.nil? && created_by == editor) ||
      editor.admin?
    )
  end

  validate on: :create do |ride|
    if ride.start_datetime <= Time.now
      ride.errors[:start_datetime] << "must come after current time"
    end
  end

  validate do |ride|
    if ride.seats == 0
      ride.errors[:seats] << "cannot have zero seats"
    end

    unless ride.end_datetime.nil? || ride.start_datetime <= ride.end_datetime
      ride.errors[:end_datetime] << "must come after start datetime"
    end

    if ride.passengers.include? ride.driver
      ride.errors[:driver] << "cannot also be a passenger"
    end

    unless ride.seats.nil? || ride.passengers.count <= ride.seats
      ride.errors[:passengers] << "do not have enough seats"
    end
  end
end
