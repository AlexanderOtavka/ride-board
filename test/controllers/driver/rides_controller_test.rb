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

  test "should get my rides" do
    get driver_my_rides_url
    assert_response :success
    assert_select ".ride-thumbnail", 2
  end

  test "should get new" do
    get new_driver_ride_url
    assert_response :success
  end

  test "should join ride as driver" do
    post driver_join_ride_url(rides(:driverless))
    assert_equal users(:driver), rides(:driverless).reload.driver
  end

  test "joining a ride subscribes you" do
    assert_difference -> {RideNotificationSubscription.count} do
      post driver_join_ride_url(rides(:driverless))
    end

    assert rides(:driverless).notification_subscribers.include? users(:driver)
    assert_equal(
      "driver",
      rides(:driverless).notification_subscriptions
        .where(user: users(:driver)).first.app
    )
  end

  test "should not be able join ride that has a driver" do
    sign_in users(:admin)
    post driver_join_ride_url(rides(:creator_created))
    assert_not_equal users(:admin), rides(:creator_created).reload.driver
  end

  test "should not be able drive for a ride when you are a passenger" do
    sign_in users(:creator)
    post driver_join_ride_url(rides(:driverless))
    assert_nil rides(:driverless).reload.driver
  end

  test "should leave a ride as driver" do
    ride = rides(:creator_created)
    delete driver_join_ride_url(ride)
    assert_nil ride.reload.driver
    assert_redirected_to driver_rides_url
  end

  test "leaving a ride unsubscribes you" do
    sign_in users(:driver)

    assert_difference -> {RideNotificationSubscription.count}, -1 do
      delete driver_join_ride_url(rides(:driver_created))
    end

    assert_not rides(:driver_created).notification_subscribers.include? users(:driver)
  end

  test "can leave a ride you aren't subscribed to" do
    sign_in users(:driver)

    assert_no_difference -> {RideNotificationSubscription.count} do
      delete driver_join_ride_url(rides(:creator_created))
    end

    assert_not rides(:creator_created).notification_subscribers.include? users(:driver)
    assert_redirected_to driver_rides_url
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
          seats: @ride.seats,
        }
      }
    end

    assert_equal users(:driver), Ride.last.driver

    assert_redirected_to driver_ride_url(Ride.last)
  end

  test "shouldn't create a ride with 0 seats" do
    assert_no_difference -> {Ride.count} do
      post driver_rides_url, params: {
        ride: {
          start_location_id: @ride.start_location_id,
          start_datetime: @ride.start_datetime,
          end_location_id: @ride.end_location_id,
          end_datetime: @ride.end_datetime,
          price: @ride.price,
          seats: 0,
        }
      }
    end
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
