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

  test "display_name gives name field if it exists" do
    u = User.new
    u.name = "Foo"
    u.email = "foo@grinnell.edu"
    assert_equal u.name, u.display_name
  end

  test "display_name gives first part of email if name is empty" do
    u = User.new
    u.name = ""
    u.email = "bar@grinnell.edu"
    assert_equal "[bar]", u.display_name
  end

  def create_valid_user(
        name: "defaultName",
        email: "default@grinnell.edu",
        password: "GreatBigOldDefaultPassword1@!5")
    u = User.new
    u.name = name
    u.email = email
    u.password = password
    return u
  end
  test "can be the same as email" do
    assert create_valid_user(name: "bar@grinnell.edu", email: "bar@grinnell.edu").valid?
  end

  test "can use grinnell username in brackets" do
    assert create_valid_user(name: "[bar]", email: "bar@grinnell.edu").valid?
  end
end
