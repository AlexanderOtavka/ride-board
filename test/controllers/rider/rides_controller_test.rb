require 'test_helper'

class RiderRidesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin)
    @ride = rides(:creator_created)
  end

  test "should get index showing rides with drivers" do
    get rider_rides_url
    assert_response :success
    assert_select ".ride-thumbnail", 2
  end

  test "should get new" do
    get new_rider_ride_url
    assert_response :success
  end

  test "should create ride" do
    assert_difference('Ride.count') do
      post rider_rides_url, params: {
        ride: {
          start_location_id: @ride.start_location_id,
          start_datetime: @ride.start_datetime,
          end_location_id: @ride.end_location_id,
          end_datetime: @ride.end_datetime,
          price: @ride.price,
        }
      }
    end

    assert_redirected_to rider_ride_url(Ride.last)
  end

  test "should show ride" do
    get rider_ride_url(@ride)
    assert_response :success
  end

  test "should get edit" do
    get edit_rider_ride_url(@ride)
    assert_response :success
  end

  test "should update ride" do
    patch rider_ride_url(@ride), params: {
      ride: {
        driver_id: @ride.driver_id,
        end_datetime: @ride.end_datetime,
        end_location_id: @ride.end_location_id,
        price: @ride.price,
        start_datetime: @ride.start_datetime,
        start_location_id: @ride.start_location_id,
      }
    }
    assert_redirected_to rider_ride_url(@ride)
  end

  test "should destroy ride" do
    assert_difference('Ride.count', -1) do
      delete rider_ride_url(@ride)
    end

    assert_redirected_to rider_rides_url
  end
end
