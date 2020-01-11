require 'savon'

module Flights
  SOAP_URL = 'http://flightxml.flightaware.com/soap/FlightXML2/wsdl'.freeze
  class Service
    attr_reader :client
    def initialize
      if ENV['USE_REAL_FLIGHTAWARE_API'] == "true"
        @client = Savon.client(
          wsdl: SOAP_URL,
          basic_auth: [ENV['FLIGHTAWARE_API_USERNAME'],
                       ENV['FLIGHTAWARE_API_KEY']]
        )
      end
    end

    # Takes date, a flight number, an airline, and optionally airports,
    # and returns precise flight times, and hopefully a flightaware faFlightID
    # we can use to keep track of the flight in the future
    #
    # Possible return values: ApiError, [Flight]
    #
    # Backing api call: https://flightaware.com/commercial/flightxml/explorer/#op_AirlineFlightSchedules
    #
    # Right now even specifying all available information can still lead to
    #
    # Caller note: the same flight can have multiple legs
    # Caller note: the flight number must only be the number part of the flight
    # Caller note: Airline codes are three letters, and different from the ticket
    #  For example: United Airlines UA338 would be "UAL" for the airline and 338
    #  for the flight number
    # Caller note: Airports must be ICAO codes, which are 4 letters and different
    # from the IATA codes that airline passengers are used to. In general for US
    # airports the ICAO code is the IATA code prepended with a K, so LAX -> KLAX,
    # DSM -> KDSM.
    # A "full" table can be found here: https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat
    def find_flight(date:,
                    flight_number:,
                    airline:,
                    origin: nil,
                    destination: nil)
      time_range = _day_to_time_range(date)
      message = {
        startDate: time_range[0].to_i,
        endDate: time_range[1].to_i,
        airline: airline,
        origin: origin,
        destination: destination,
        flight_number: flight_number,
        howMany: 10
      }.compact!
      @client.call(:airline_flight_schedules, message: message)
        &.to_hash[:airline_flight_schedules_results][:airline_flight_schedules_result][:data]
        .map do |flight|
        flight[:departuretime] = Time.at(flight[:departuretime].to_i)
        flight[:arrivaltime] = Time.at(flight[:arrivaltime].to_i)
        flight[:origin] = _get_airport_info(flight[:origin])
        flight[:destination] = _get_airport_info(flight[:destination])
        flight
      end
    end

    def _get_airport_info(shortcode)
      resp = @client.call(:airport_info, message: {airport_code: shortcode})
      resp.to_hash[:airport_info_results][:airport_info_result]
    end

    def _get_airline_info(shortcode)
      @client.call(:airline_info, message: {airline_code: shortcode})
    end

    # Converts a Time object into [8 pm night before, 4am next day] in an attempt
    # to cover "all flights that day"
    CHICAGO_TZ = "-06:00".freeze
    def _day_to_time_range(time)
      [Time.new(time.year, time.month, time.day - 1, 20, 0, 0, CHICAGO_TZ),
       Time.new(time.year, time.month, time.day + 1, 4,  0, 0, CHICAGO_TZ)]
    end
  end
end
