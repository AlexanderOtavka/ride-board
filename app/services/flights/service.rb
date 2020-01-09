require 'savon'

module Flights
  SOAP_URL = 'http://flightxml.flightaware.com/soap/FlightXML2/wsdl'


  class Service
    def initialize
      if ENV['USE_REAL_FLIGHTAWARE_API'] == "true"
        @client = Savon.client(
          wsdl: SOAP_URL,
          basic_auth: [ENV['FLIGHTAWARE_API_USERNAME'],
                       ENV['FLIGHTAWARE_API_KEY']]
        )
      end
    end

    # Takes date, and either a flight number (with carrier) or airports,
    # and returns precise flight times, and hopefully a flightaware faFlightID
    # we can use to keep track of the flight in the future
    #
    # Possible return values: ApiError, [Flight]
    #
    # Will stem mostly from https://flightaware.com/commercial/flightxml/explorer/#op_AirlineFlightSchedules
    #
    # Caller note: there do not appear to be guarantees that there will only be one
    # flight for a given flight number, so we should be prepared to handle the case
    # where we get multiple back
    def find_flight(date:,
                    airline: nil,
                    flight_number: nil,
                    departure_airport: nil,
                    destination_airport: nil)
    end

    # Converts a Time object into [8 pm night before, 4am next day] in an attempt
    # to cover "all flights that day"
    CHICAGO_TZ = "-06:00"
    def _day_to_time_range(time)
      [Time.new(2019, time.month, time.day - 1, 20, 0, 0, CHICAGO_TZ),
       Time.new(2019, time.month, time.day + 1, 4, 0, 0, CHICAGO_TZ)]
    end
  end
end
