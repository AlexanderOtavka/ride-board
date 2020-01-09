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
end
