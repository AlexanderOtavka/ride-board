class Passenger::RidesController < Passenger::BaseController
  include RideManager

  # GET /rides
  # GET /rides.json
  def index
    @search = search_params
    Rails.logger.debug "SEARCH PARAMS #{@search.inspect}"
    @available_rides = Ride.available_for_passenger(
      current_user: current_user,
      search: @search,
    )
    @other_rides = Ride.driverless(
      current_user: current_user,
      search: @search,
    )
  end

  # GET /rides/1
  # GET /rides/1.json
  def show
  end

  # GET /rides/new
  def new
    @ride = Ride.new
  end

  # GET /rides/1/edit
  def edit
  end

  # POST /rides
  # POST /rides.json
  def create
    @ride = Ride.new(passenger_ride_params.merge(
      driver: nil,
      created_by: current_user,
      passengers: [current_user],
      notification_subscriptions: [RideNotificationSubscription.new(
        user: current_user,
        app: :passenger
      )],
    ))

    respond_to do |format|
      if @ride.save
        format.html { redirect_to passenger_ride_path(@ride),
                                  notice: 'Ride was successfully created.' }
        format.json { render :show, status: :created, location: @ride }
      else
        format.html { render :new }
        format.json { render json: @ride.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rides/1
  # PATCH/PUT /rides/1.json
  def update
    respond_to do |format|
      if @ride.update(passenger_ride_params)
        format.html { redirect_to passenger_ride_path(@ride),
                                  notice: 'Ride was successfully updated.' }
        format.json { render :show, status: :ok, location: @ride }
      else
        format.html { render :edit }
        format.json { render json: @ride.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rides/1
  # DELETE /rides/1.json
  def destroy
    @ride.destroy
    respond_to do |format|
      format.html { redirect_to passenger_rides_url,
                                notice: 'Ride was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /rides/1/join
  def join
    valid = false
    SeatAssignment.transaction do
      if @ride.passengers.include? current_user
        @ride.errors[:base] << "you have already joined this ride"
      else
        @ride.passengers << current_user
        valid = @ride.save
      end
      raise ActiveRecord::Rollback unless valid
    end

    respond_to do |format|
      if valid
        unless @ride.notification_subscribers.include? current_user
          @ride.notification_subscriptions.create!(
            user: current_user, app: :passenger)
        end

        if @ride.notification_subscribers.include? @ride.driver
          Notifier::Service.new.notify(@ride.driver,
            "A new passenger (#{current_user.display_name}) just joined your ride. " +
            "See #{short_driver_ride_url(@ride)} for details.")
        end

        format.html { redirect_to passenger_ride_path(@ride),
                                  notice: 'Ride was successfully joined.' }
        format.json { render :show, status: :created, location: @ride }
      else
        @errors = @ride.errors
        @problem = "Couldn't join ride"
        format.html { render :show }
        format.json { render json: @ride.errors, status: :forbidden }
      end
    end
  end

  # DELETE /rides/1/join
  def leave
    respond_to do |format|
      SeatAssignment.transaction do
        if @ride.passengers.include? current_user
          @ride.passengers.delete current_user
          @ride.notification_subscribers.delete current_user

          if @ride.notification_subscribers.include? @ride.driver
            Notifier::Service.new.notify(@ride.driver,
              "A passenger (#{current_user.display_name}) just left your ride. " +
              "See #{short_driver_ride_url(@ride)} for details.")
          end

          format.html { redirect_to passenger_ride_path(@ride),
                                    notice: 'You have left this ride.' }
          format.json { render :show, status: :created, location: @ride }
        else
          message = 'You have already left this ride'
          format.html { redirect_to passenger_ride_path(@ride), notice: message }
          format.json { render json: { message: message }, status: :forbidden }
        end
      end
    end
  end

  private

    def passenger_ride_params
      ride_params
    end

end
