require 'test_helper'

class PassengerRidesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin)
  end

  test "should get index showing ride groups with empty seats" do
    get passenger_rides_url
    assert_response :success
    assert_select "#available-rides" do
      assert_select ".ride-thumbnail", 1
    end

    assert_select "#other-rides" do
      assert_select ".ride-thumbnail", 1
    end
  end

  test "should get my rides" do
    sign_in users(:creator)
    get passenger_my_rides_url
    assert_response :success
    assert_select ".ride-thumbnail", 2
  end

  test "should get new" do
    get new_passenger_ride_url
    assert_response :success
  end

  test "should join a ride" do
    assert_difference -> {SeatAssignment.count} do
      post passenger_join_ride_url(rides(:driver_created))
    end

    assert rides(:driver_created).passengers.include? users(:admin)
  end

  test "joining a ride subscribes you" do
    assert_difference -> {RideNotificationSubscription.count} do
      post passenger_join_ride_url(rides(:driver_created))
    end

    assert rides(:driver_created).notification_subscribers.include? users(:admin)
    assert_equal(
      "passenger",
      rides(:driver_created).ride_notification_subscriptions
        .where(user: users(:admin)).first.app
    )
  end

  test "can't join a ride if you are the driver" do
    sign_in users(:driver)

    assert_no_difference -> {SeatAssignment.count} do
      post passenger_join_ride_url(rides(:creator_created))
    end

    assert_not rides(:creator_created).passengers.include? users(:driver)
  end

  test "can't join a ride if it is full" do
    sign_in users(:passenger)

    assert_no_difference -> {SeatAssignment.count} do
      post passenger_join_ride_url(rides(:creator_created))
    end

    assert_not rides(:creator_created).passengers.include? users(:passenger)
  end

  test "should leave a ride" do
    sign_in users(:creator)

    assert_difference -> {SeatAssignment.count}, -1 do
      delete passenger_join_ride_url(rides(:creator_created))
    end

    assert_not rides(:creator_created).passengers.include? users(:creator)
    assert_redirected_to passenger_rides_url
  end

  test "leaving a ride unsubscribes you" do
    sign_in users(:creator)

    assert_difference -> {RideNotificationSubscription.count}, -1 do
      delete passenger_join_ride_url(rides(:creator_created))
    end

    assert_not rides(:creator_created).notification_subscribers.include? users(:creator)
  end

  test "can leave a ride you aren't subscribed to" do
    sign_in users(:creator)

    assert_no_difference -> {RideNotificationSubscription.count} do
      delete passenger_join_ride_url(rides(:driverless))
    end

    assert_not rides(:driverless).notification_subscribers.include? users(:creator)
    assert_redirected_to passenger_rides_url
  end

  test "should create ride" do
    assert_difference -> {Ride.count} do
      post passenger_rides_url, params: {
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
    assert Ride.last.passengers.include? users(:admin)

    assert_redirected_to passenger_ride_url(Ride.last)
  end

  test "should show ride" do
    get passenger_ride_url(rides(:creator_created))
    assert_response :success
  end

  test "should get edit" do
    get edit_passenger_ride_url(rides(:creator_created))
    assert_response :success
  end

  test "should update ride" do
    patch passenger_ride_url(rides(:creator_created)), params: {
      ride: {
        driver_id: rides(:creator_created).driver_id,
        end_datetime: rides(:creator_created).end_datetime,
        end_location_id: rides(:creator_created).end_location_id,
        price: rides(:creator_created).price,
        start_datetime: rides(:creator_created).start_datetime,
        start_location_id: rides(:creator_created).start_location_id,
      }
    }
    assert_redirected_to passenger_ride_url(rides(:creator_created))
  end

  test "should destroy ride" do
    assert_difference('Ride.count', -1) do
      delete passenger_ride_url(rides(:creator_created))
    end

    assert_redirected_to passenger_rides_url
  end
end
