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

  test "ride does not allow rider edits" do
    assert_not rides(:creator_created).authorized_editor? users(:rider)
  end

  test "has a passenger with a seating assignment" do
    assert rides(:creator_created).has_passenger? users(:creator)
  end

  test "doesn't have a passenger with no seating assignment" do
    assert_not rides(:creator_created).has_passenger? users(:driver)
  end

  test "doesn't have nil passenger" do
    assert_not rides(:creator_created).has_passenger? nil
  end

  test "ride does not allow a passenger to become the driver" do
    rides(:driverless).driver = users(:creator)
    assert_not rides(:driverless).valid?
  end

  test "ride does not allow driver to become a passenger" do
    rides(:driver_created).passengers << users(:driver)
    assert_not rides(:driver_created).valid?
  end

  test "ride destorys itself when it has no more driver or passengers" do
    assert_difference -> {Ride.count}, -1 do
      rides(:driverless).passengers = []
      rides(:driverless).save
    end

    assert_difference -> {Ride.count}, -1 do
      rides(:driver_created).driver = nil
      rides(:driver_created).save
    end
  end
end
