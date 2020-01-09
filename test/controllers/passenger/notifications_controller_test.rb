require 'test_helper'

class Passenger::NotificationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:passenger)
    sign_in @user
  end

  test "can get show page" do
    get passenger_notify_url
    assert_response :success
  end

  test "can update notification preferences" do
    patch passenger_notify_url, params: {
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

  test "can't notify sms without a phone number" do
    patch passenger_notify_url, params: {
      user: {
        notify_sms: true,
      }
    }

    @user.reload
    assert_not @user.notify_sms?
  end
end
