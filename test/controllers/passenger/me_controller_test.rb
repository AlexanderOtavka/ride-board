require 'test_helper'

class Passenger::MeControllerTest < ActionDispatch::IntegrationTest
  test "should get my rides" do
    sign_in users(:creator)
    get passenger_me_url
    assert_response :success
    assert_select "#upcoming-rides .rb-ride-thumbnail", 2
    assert_select "#past-rides .rb-ride-thumbnail", 1
  end
end
