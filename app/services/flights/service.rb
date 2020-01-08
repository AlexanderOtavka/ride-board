class Flights::Service
  # Takes date and flight number and returns precise flight times,
  # and hopefully a flightaware faFlightID we can use to keep track of the flight
  # in the future
  #
  # Possible results: ApiError, FlightNotFound, NonEmpty [Flight]
  #
  # Will stem mostly from https://flightaware.com/commercial/flightxml/explorer/#op_AirlineFlightSchedules
  #
  # Caller note: there do not appear to be guarantees that there will only be one
  # flight for a given flight number, so we should be prepared to handle the case
  # where we get multiple back
  def find_flight_by_number
  end

  # Similar to find_flight_by_number, but returns a list of flights to pick from
  #
  # Possible results: ApiError, [Flight]
  #
  # Uses same api endpoint as find_flight_by_number
  def find_flight_by_airport
  end
end
