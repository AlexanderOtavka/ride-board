require 'test_helper'

class Driver::MeControllerTest < ActionDispatch::IntegrationTest
  test "should get my rides" do
    sign_in users(:driver)
    get driver_me_url
    assert_response :success
    assert_select "#upcoming-rides .rb-ride-thumbnail", 3
    assert_select "#past-rides .rb-ride-thumbnail", 1
  end
end
