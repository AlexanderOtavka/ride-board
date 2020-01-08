require 'test_helper'

class PassengerMessagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:driver)
  end

  test "can post a message" do
    ride = rides(:driver_created)

    assert_difference -> {ride.reload.messages.count} do
      post passenger_ride_messages_url(ride), params: {
        message: { content: "Hello there" }
      }
    end

    assert_redirected_to passenger_ride_url(ride, anchor: "latest-message")
  end

  test "posting a message subscribes you to the ride" do
    user = users(:creator)
    ride = rides(:driverless)
    sign_in user

    assert_difference -> {RideNotificationSubscription.count} do
      post passenger_ride_messages_url(ride), params: {
        message: { content: "Hello there" }
      }
    end

    assert ride.notification_subscribers.include? user
    assert_equal "passenger", ride.notification_subscriptions.where(user: user).first.app
  end

  test "post message subscription is idempotent" do
    user = users(:creator)
    ride = rides(:creator_created)
    sign_in user

    assert_no_difference -> {RideNotificationSubscription.count} do
      post passenger_ride_messages_url(ride), params: {
        message: { content: "Hello there" }
      }
    end

    assert ride.notification_subscribers.include? user
  end

  test "can't post an empty message" do
    ride = rides(:driver_created)

    assert_no_difference -> {ride.reload.messages.count} do
      post passenger_ride_messages_url(ride), params: {
        message: { content: "" }
      }
    end

    assert_redirected_to passenger_ride_url(ride, anchor: "latest-message")
  end
end
