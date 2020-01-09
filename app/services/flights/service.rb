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

    # Errors to handle: SocketError -> Failed to open TCP connection due to name resolution failure
  end

end
