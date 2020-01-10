json.extract! ride, :id, :start_location, :start_datetime, :end_location, :end_datetime, :driver_id, :price, :created_at, :updated_at
json.url ride_url(ride, format: :json)
