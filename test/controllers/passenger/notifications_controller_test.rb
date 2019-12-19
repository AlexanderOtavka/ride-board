require 'test_helper'

class Passenger::NotificationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:creator)
    @ride = rides(:creator_created)
  end

  test "can get show page" do
    get passenger_ride_notify_url(@ride)
    assert_response :success
  end
end
