require 'test_helper'

class RideTest < ActiveSupport::TestCase
  test "ride allows admin edits" do
    assert rides(:one).authorized_editor? users(:admin)
  end

  test "ride allows driver edits" do
    assert rides(:one).authorized_editor? users(:driver)
  end

  test "ride does not allow rider edits" do
    assert_not rides(:one).authorized_editor? users(:rider)
  end
end
