require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get index" do
    get root_url
    assert_response :success
  end

  test "should redirect rides with drivers" do
    ride = rides(:driver_created)
    get share_ride_url(ride)
    assert_redirected_to passenger_ride_url(ride)
  end

  test "should render a page for rides without drivers" do
    ride = rides(:driverless)
    get share_ride_url(ride)
    assert_response :success
  end
end
