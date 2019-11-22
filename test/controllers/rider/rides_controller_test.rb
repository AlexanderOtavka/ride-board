require 'test_helper'

class RiderRidesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin)
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

  test "should join a ride" do
    assert_difference -> {SeatAssignment.count} do
      post rider_join_ride_url(rides(:driver_created))
    end

    assert rides(:driver_created).has_passenger? users(:admin)
  end

  test "can't join a ride if you are the driver" do
    sign_in users(:driver)

    assert_no_difference -> {SeatAssignment.count} do
      post rider_join_ride_url(rides(:creator_created))
    end

    assert_not rides(:creator_created).has_passenger? users(:driver)
  end

  test "can't join a ride if it is full" do
    sign_in users(:rider)

    assert_no_difference -> {SeatAssignment.count} do
      post rider_join_ride_url(rides(:creator_created))
    end

    assert_not rides(:creator_created).has_passenger? users(:rider)
  end

  test "should leave a ride" do
    sign_in users(:creator)

    assert_difference -> {SeatAssignment.count}, -1 do
      delete rider_leave_ride_url(rides(:creator_created))
    end

    assert_not rides(:creator_created).has_passenger? users(:creator)
  end

  test "should create ride" do
    assert_difference -> {Ride.count} do
      post rider_rides_url, params: {
        ride: {
          start_location_id: rides(:creator_created).start_location_id,
          start_datetime: rides(:creator_created).start_datetime,
          end_location_id: rides(:creator_created).end_location_id,
          end_datetime: rides(:creator_created).end_datetime,
          price: rides(:creator_created).price,
        }
      }
    end

    assert_nil Ride.last.driver
    assert Ride.last.has_passenger? users(:admin)

    assert_redirected_to rider_ride_url(Ride.last)
  end

  test "should show ride" do
    get rider_ride_url(rides(:creator_created))
    assert_response :success
  end

  test "should get edit" do
    get edit_rider_ride_url(rides(:creator_created))
    assert_response :success
  end

  test "should update ride" do
    patch rider_ride_url(rides(:creator_created)), params: {
      ride: {
        driver_id: rides(:creator_created).driver_id,
        end_datetime: rides(:creator_created).end_datetime,
        end_location_id: rides(:creator_created).end_location_id,
        price: rides(:creator_created).price,
        start_datetime: rides(:creator_created).start_datetime,
        start_location_id: rides(:creator_created).start_location_id,
      }
    }
    assert_redirected_to rider_ride_url(rides(:creator_created))
  end

  test "should destroy ride" do
    assert_difference('Ride.count', -1) do
      delete rider_ride_url(rides(:creator_created))
    end

    assert_redirected_to rider_rides_url
  end
end
