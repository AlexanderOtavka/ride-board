require 'test_helper'

class DriverRidesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:driver)
    @ride = rides(:creator_created)
  end

  test "should get index showing rides without drivers" do
    get driver_rides_url
    assert_response :success
    assert_select ".ride-thumbnail", 1
  end

  test "should get new" do
    get new_driver_ride_url
    assert_response :success
  end

  test "should create ride" do
    assert_difference -> {Ride.count} do
      post driver_rides_url, params: {
        ride: {
          start_location_id: @ride.start_location_id,
          start_datetime: @ride.start_datetime,
          end_location_id: @ride.end_location_id,
          end_datetime: @ride.end_datetime,
          price: @ride.price,
        }
      }
    end

    assert_equal users(:driver), Ride.last.driver

    assert_redirected_to driver_ride_url(Ride.last)
  end

  test "should show ride" do
    get driver_ride_url(@ride)
    assert_response :success
  end

  test "should get edit" do
    get edit_driver_ride_url(@ride)
    assert_response :success
  end

  test "should update ride" do
    patch driver_ride_url(@ride), params: {
      ride: {
        driver_id: @ride.driver_id,
        end_datetime: @ride.end_datetime,
        end_location: @ride.end_location,
        price: @ride.price,
        start_datetime: @ride.start_datetime,
        start_location: @ride.start_location
      }
    }
    assert_redirected_to driver_ride_url(@ride)
  end

  test "should destroy ride" do
    assert_difference('Ride.count', -1) do
      delete driver_ride_url(@ride)
    end

    assert_redirected_to driver_rides_url
  end
end
