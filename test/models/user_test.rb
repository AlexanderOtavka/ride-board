require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "has a notifier with a subscription" do
    assert users(:creator).notifying_rides.include? rides(:creator_created)
  end

  test "doesn't have a notifier with no subscription" do
    assert_not users(:creator).notifying_rides.include? rides(:driver_created)
  end

  test "doesn't have nil notifier" do
    assert_not users(:creator).notifying_rides.include? nil
  end
end
