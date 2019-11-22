require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get index when no user is signed in" do
    get root_url
    assert_response :success
  end

  test "should redirect to passenger app when user is a passenger" do
    sign_in users(:passenger)
    get root_url
    assert_redirected_to passenger_root_url
  end

  test "should redirect to driver app when user is a driver" do
    sign_in users(:driver)
    get root_url
    assert_redirected_to driver_root_url
  end
end
