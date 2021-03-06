require 'test_helper'

class RideTest < ActiveSupport::TestCase
  test "ride allows admin edits" do
    assert rides(:creator_created).authorized_editor? users(:admin)
  end

  test "ride allows driver edits" do
    assert rides(:creator_created).authorized_editor? users(:driver)
  end

  test "ride allows creator edits when there is no driver" do
    assert rides(:driverless).authorized_editor? users(:creator)
  end

  test "ride does not allow creator edits when there is a driver" do
    assert_not rides(:creator_created).authorized_editor? users(:creator)
  end

  test "ride does not allow passenger edits" do
    assert_not rides(:creator_created).authorized_editor? users(:passenger)
  end

  test "has passengers with a seating assignments" do
    ride = rides(:driver_created)
    assert_equal 2, ride.passengers.count
    assert ride.passengers.include? users(:several_rides_passenger)
    assert ride.passengers.include? users(:other_passenger)
  end

  test "doesn't have a passenger with no seating assignment" do
    assert_not rides(:driver_created).passengers.include? users(:creator)
  end

  test "doesn't have nil passenger" do
    assert_not rides(:driver_created).passengers.include? nil
  end

  test "has subscribers with subscriptions" do
    ride = rides(:driver_created)
    assert_equal 3, ride.notification_subscribers.count
    assert ride.notification_subscribers.include? users(:driver)
    assert ride.notification_subscribers.include? users(:passenger)
    assert ride.notification_subscribers.include? users(:several_rides_passenger)
  end

  test "doesn't have a subscriber with no subscription" do
    assert_not rides(:driver_created).notification_subscribers.include? users(:creator)
  end

  test "doesn't have nil subscriber" do
    assert_not rides(:driver_created).notification_subscribers.include? nil
  end

  test "not all subscribers or passengers are passenger subscribers" do
    assert_equal 1, rides(:driver_created).notified_passengers.count
    assert rides(:driver_created).notified_passengers.include? users(:several_rides_passenger)
  end

  test "ride does not allow a passenger to become the driver" do
    rides(:driverless).driver = users(:creator)
    assert_not rides(:driverless).valid?
  end

  test "ride does not allow driver to become a passenger" do
    rides(:driver_created).passengers << users(:driver)
    assert_not rides(:driver_created).valid?
  end

  test "ride stays when it has no more drivers or passengers" do
    no_driver = rides(:driverless)
    no_passengers = rides(:past_with_driver)
    assert no_passengers.passengers.empty?

    assert_no_difference -> {Ride.count} do
      no_driver.passengers = []
      no_driver.save
    end

    assert_no_difference -> {Ride.count} do
      no_passengers.driver = nil
      no_passengers.save
    end
  end

  test "list sorts rides and excludes abandoned rides" do
    assert_equal(
      [
        rides(:past_with_driver),
        rides(:past_without_driver),
        rides(:creator_created),
        rides(:creator_created_with_open_seats),
        rides(:driver_created),
        rides(:driver_created_full),
        rides(:driverless),
        rides(:driverless2),
      ],
      Ride.list(Ride.all)
    )
  end

  test "lists available rides for a passenger" do
    user = users(:passenger)
    assert_equal(
      [rides(:creator_created_with_open_seats), rides(:driver_created)],
      Ride.available_for_passenger(current_user: user, search: nil)
    )
  end

  test "available rides don't include rides the passenger is in" do
    user = users(:other_passenger)
    assert_equal(
      [rides(:creator_created_with_open_seats)],
      Ride.available_for_passenger(current_user: user, search: nil)
    )
  end

  test "available rides don't include rides the current user is this driver" do
    user = users(:admin)
    assert_equal(
      [rides(:driver_created)],
      Ride.available_for_passenger(current_user: user, search: nil)
    )
  end

  test "lists driverless rides for a driver" do
    user = users(:driver)
    assert_equal(
      [rides(:driverless), rides(:driverless2)],
      Ride.driverless(current_user: user, search: nil)
    )
  end

  test "lists driverless rides that passenger is not in" do
    user = users(:several_rides_passenger)
    assert_equal(
      [rides(:driverless2)],
      Ride.driverless(current_user: user, search: nil)
    )
  end

  test "searches for a location in either the start or end field" do
    assert_equal(
      [
        rides(:creator_created_with_open_seats),
        rides(:driver_created_full),
        rides(:driverless2),
      ],
      Ride.search(
        Ride.list(Ride.all),
        location: locations(:des_moines),
        date: nil
      )
    )
  end

  test "searches for a date" do
    assert_equal(
      [
        rides(:driverless),
      ],
      Ride.search(
        Ride.list(Ride.all),
        location: nil,
        date: 5.days.from_now.to_date
      )
    )
  end

  test "searches for both a location and a date" do
    assert_equal(
      [
        rides(:creator_created_with_open_seats),
        rides(:driver_created_full),
      ],
      Ride.search(
        Ride.list(Ride.all),
        location: locations(:des_moines),
        date: 2.days.from_now.to_date
      )
    )
  end
end
