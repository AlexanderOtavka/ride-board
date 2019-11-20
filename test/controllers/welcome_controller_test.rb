require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get index when no user is signed in" do
    get root_url
    assert_response :success
  end

  test "should redirect to rider app when user is a rider" do
    sign_in users(:rider)
    get root_url
    assert_redirected_to rider_root_url
  end

  test "should redirect to driver app when user is a driver" do
    sign_in users(:driver)
    get root_url
    assert_redirected_to driver_root_url
  end
end
