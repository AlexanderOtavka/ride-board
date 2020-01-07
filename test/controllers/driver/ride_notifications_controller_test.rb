require 'test_helper'

class Driver::RideNotificationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:driver)
    @ride = rides(:creator_created)
    sign_in @user
  end

  test "can get show page" do
    get driver_ride_notify_url(@ride)
    assert_response :success
  end

  test "can update notification preferences" do
    patch driver_ride_notify_url(@ride), params: {
      ride: {
        notify: false,
      },
      user: {
        notify_sms: true,
        notify_email: true,
        phone_number: "1234567890"
      }
    }

    @user.reload
    assert @user.notify_sms?
    assert @user.notify_email?
    assert_equal "1234567890", @user.phone_number
  end

  test "can add a subscription" do
    assert_difference -> {RideNotificationSubscription.count} do
      patch driver_ride_notify_url(@ride), params: {
        ride: {
          notify: true,
        },
        user: {
          notify_sms: false,
          notify_email: true,
          phone_number: ""
        }
      }
    end

    assert @ride.notification_subscribers.include? @user
    assert_equal "driver", @ride.notification_subscriptions.where(user: @user).first.app
  end

  test "adding a subscription is idempotent" do
    @ride = rides(:driver_created)

    assert_no_difference -> {RideNotificationSubscription.count} do
      patch driver_ride_notify_url(@ride), params: {
        ride: {
          notify: true,
        },
        user: {
          notify_sms: false,
          notify_email: true,
          phone_number: ""
        }
      }
    end
  end

  test "can remove a subscription" do
    @ride = rides(:driver_created)

    assert_difference -> {RideNotificationSubscription.count}, -1 do
      patch driver_ride_notify_url(@ride), params: {
        ride: {
          notify: false,
        },
        user: {
          notify_sms: false,
          notify_email: true,
          phone_number: ""
        }
      }
    end

    assert_not @ride.notification_subscribers.include? @user
  end

  test "removing a subscription is idempotent" do
    assert_no_difference -> {RideNotificationSubscription.count} do
      patch driver_ride_notify_url(@ride), params: {
        ride: {
          notify: false,
        },
        user: {
          notify_sms: false,
          notify_email: true,
          phone_number: ""
        }
      }
    end
  end

  test "can't notify sms without a phone number" do
    patch driver_ride_notify_url(@ride), params: {
      user: {
        notify_sms: true,
      }
    }

    @user.reload
    assert_not @user.notify_sms?
  end
end
