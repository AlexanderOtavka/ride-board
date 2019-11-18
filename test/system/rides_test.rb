require "application_system_test_case"

class RidesTest < ApplicationSystemTestCase
  setup do
    @ride = rides(:one)
  end

  test "visiting the index" do
    visit rides_url
    assert_selector "h1", text: "Rides"
  end

  test "creating a Ride" do
    visit rides_url
    click_on "New Ride"

    fill_in "Driver", with: @ride.driver_id
    fill_in "End datetime", with: @ride.end_datetime
    fill_in "End location", with: @ride.end_location
    fill_in "Price", with: @ride.price
    fill_in "Start datetime", with: @ride.start_datetime
    fill_in "Start location", with: @ride.start_location
    click_on "Create Ride"

    assert_text "Ride was successfully created"
    click_on "Back"
  end

  test "updating a Ride" do
    visit rides_url
    click_on "Edit", match: :first

    fill_in "Driver", with: @ride.driver_id
    fill_in "End datetime", with: @ride.end_datetime
    fill_in "End location", with: @ride.end_location
    fill_in "Price", with: @ride.price
    fill_in "Start datetime", with: @ride.start_datetime
    fill_in "Start location", with: @ride.start_location
    click_on "Update Ride"

    assert_text "Ride was successfully updated"
    click_on "Back"
  end

  test "destroying a Ride" do
    visit rides_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Ride was successfully destroyed"
  end
end
