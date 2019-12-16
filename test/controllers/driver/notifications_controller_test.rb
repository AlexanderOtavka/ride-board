require 'test_helper'

class Driver::NotificationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:driver)
    @ride = rides(:creator_created)
  end

  test "can get show page" do
    get driver_ride_notify_url(@ride)
    assert_response :success
  end
end
