class Driver::RidesController < Driver::BaseController
  include RideManager

  # GET /rides
  # GET /rides.json
  def index
    @rides = future_rides.where(driver_id: nil)
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
    @ride = Ride.new(driver_ride_params.merge(
      driver: current_user,
      created_by: current_user,
      notification_subscriptions: [RideNotificationSubscription.new(
        user: current_user,
        app: :driver
      )],
    ))

    respond_to do |format|
      if @ride.save
        format.html { redirect_to driver_ride_path(@ride),
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
      if @ride.update(driver_ride_params)

        notifier = Notifier::Service.new
        @ride.notified_passengers.each do |passenger|
          notifier.notify(passenger,
            "Your driver made a change to your ride. " +
            "See #{short_passenger_ride_url(@ride)} for details")
        end

        format.html { redirect_to driver_ride_path(@ride),
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
      format.html { redirect_to driver_rides_url, notice: 'Ride was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /rides/1/join
  def join
    valid = true

    if @ride.driver == current_user
      @ride.errors[:base] << "you are already the driver"
      valid = false
    elsif !@ride.driver.nil?
      @ride.errors[:driver] << "has already taken this ride"
      valid = false
    end

    @ride.driver = current_user

    respond_to do |format|
      if valid && @ride.save
        unless @ride.notification_subscribers.include? current_user
          @ride.notification_subscriptions.create!(
            user: current_user, app: :driver)
        end

        notifier = Notifier::Service.new
        @ride.notified_passengers.each do |passenger|
          notifier.notify(passenger,
            "A driver (#{current_user.display_name}) just accepted your ride request. " +
            "See #{short_passenger_ride_url(@ride)} for details.")
        end

        format.html { redirect_to driver_ride_path(@ride),
                                  notice: 'You are now the driver.' }
        format.json { render :show, status: :created, location: @ride }
      else
        @errors = @ride.errors
        @problem = "Cannot drive for ride"
        format.html { render :show }
        format.json { render json: @ride.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rides/1/join
  def leave
    respond_to do |format|
      if @ride.driver == current_user
        @ride.driver = nil
        @ride.save

        @ride.notification_subscribers.delete current_user

        notifier = Notifier::Service.new
        @ride.notified_passengers.each do |passenger|
          notifier.notify(passenger,
            "Your driver (#{current_user.display_name}) will no longer be driving for you! " +
            "See #{short_passenger_ride_url(@ride)} for details.")
        end

        format.html { redirect_to driver_rides_path,
                                  notice: 'You have left this ride.' }
        format.json { render :show, status: :created, location: @ride }
      else
        message = 'You have already left this ride'
        format.html { redirect_to driver_rides_path, notice: message }
        format.json { render json: { message: message },
                              status: :forbidden }
      end
    end
  end

  private

    def driver_ride_params
      ride_params permit: [:seats]
    end

end
