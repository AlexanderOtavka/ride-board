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
end
