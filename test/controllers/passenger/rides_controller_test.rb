require 'test_helper'

class PassengerRidesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:admin)
    sign_in @user
  end

  test "should get index showing ride groups with empty seats" do
    get passenger_rides_url
    assert_response :success
    assert_select "#available-rides .rb-ride-thumbnail", 1
    assert_select "#other-rides .rb-ride-thumbnail", 2
  end

  test "should get new" do
    get new_passenger_ride_url
    assert_response :success
  end

  test "should join a ride" do
    ride = rides(:driver_created)

    assert_difference -> {SeatAssignment.count} do
      post passenger_join_ride_url(ride)
    end

    assert ride.passengers.include? @user
  end

  test "join fails gracefully if they are already joined" do
    user = users(:creator)
    ride = rides(:creator_created)
    sign_in user

    assert_no_difference -> {SeatAssignment.count} do
      post passenger_join_ride_url(ride)
    end

    assert_response :success
    assert ride.passengers.include? user
  end

  test "joining a ride subscribes you" do
    assert_difference -> {RideNotificationSubscription.count} do
      post passenger_join_ride_url(rides(:driver_created))
    end

    assert rides(:driver_created).notification_subscribers.include? users(:admin)
    assert_equal(
      "passenger",
      rides(:driver_created).notification_subscriptions
        .where(user: users(:admin)).first.app
    )
  end

  test "subscription on join is idempotent" do
    user = users(:passenger)
    ride = rides(:driver_created)
    sign_in user

    assert_difference -> {SeatAssignment.count} => 1,
                      -> {RideNotificationSubscription.count} => 0 do
      post passenger_join_ride_url(ride)
    end

    assert ride.notification_subscribers.include? user
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
    user = users(:creator)
    ride = rides(:creator_created)
    sign_in user

    assert_difference -> {SeatAssignment.count}, -1 do
      delete passenger_join_ride_url(ride)
    end

    assert_not ride.passengers.include? user
    assert_redirected_to passenger_ride_url(ride)
  end

  test "leaving a ride unsubscribes you" do
    sign_in users(:creator)

    assert_difference -> {RideNotificationSubscription.count}, -1 do
      delete passenger_join_ride_url(rides(:creator_created))
    end

    assert_not rides(:creator_created).notification_subscribers.include? users(:creator)
  end

  test "can leave a ride you aren't subscribed to" do
    user = users(:creator)
    ride = rides(:driverless)
    sign_in user

    assert_no_difference -> {RideNotificationSubscription.count} do
      delete passenger_join_ride_url(ride)
    end

    assert_not ride.notification_subscribers.include? user
    assert_redirected_to passenger_ride_url(ride)
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

  test "creating a ride subscribes to it" do
    assert_difference -> {RideNotificationSubscription.count} do
      post passenger_rides_url, params: {
        ride: {
          start_location_id: rides(:creator_created).start_location_id,
          start_datetime: rides(:creator_created).start_datetime,
          end_location_id: rides(:creator_created).end_location_id,
          end_datetime: rides(:creator_created).end_datetime,
        }
      }
    end

    ride = Ride.last

    assert ride.notification_subscribers.include? @user
    assert_equal "passenger", ride.notification_subscriptions.where(user: @user).first.app
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
