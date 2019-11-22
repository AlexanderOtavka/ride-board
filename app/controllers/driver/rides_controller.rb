module Driver
  class RidesController < ApplicationController
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

    private

      def driver_ride_params
        ride_params permit: [:seats]
      end

  end
end
