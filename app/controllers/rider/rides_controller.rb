module Rider
  class RidesController < ApplicationController
    include RideManager

    # GET /rides
    # GET /rides.json
    def index
      @rides = future_rides.where.not(driver_id: nil)
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

    # POST /rides/1/join
    def join
      seat_assignment = SeatAssignment.new(
        ride: @ride,
        user: current_user,
      )

      respond_to do |format|
        if seat_assignment.save
          format.html { redirect_to rider_ride_path(@ride),
                                    notice: 'Ride was successfully joined.' }
          format.json { render :show, status: :created, location: @ride }
        else
          @errors = seat_assignment.errors
          @problem = "Couldn't join ride"
          format.html { render :show }
          format.json { render json: seat_assignment.errors, status: :forbidden }
        end
      end
    end

    # DELETE /rides/1/join
    def leave
      seat_assignments = SeatAssignment.where(user: current_user, ride: @ride)
      respond_to do |format|
        if seat_assignments.exists?
          seat_assignments.destroy_all
          format.html { redirect_to rider_ride_path(@ride),
                                    notice: 'You have left this ride.' }
          format.json { render :show, status: :created, location: @ride }
        else
          message = 'You have alread left this ride'
          format.html { render :show, notice: message }
          format.json { render json: { message: message },
                               status: :forbidden }
        end
      end
    end

    # POST /rides
    # POST /rides.json
    def create
      @ride = Ride.new(rider_ride_params.merge(
        driver: nil,
        created_by: current_user,
      ))

      seat_assignment = SeatAssignment.new(
        ride: @ride,
        user: current_user,
      )

      respond_to do |format|
        if @ride.save && seat_assignment.save
          format.html { redirect_to rider_ride_path(@ride),
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
        if @ride.update(rider_ride_params)
          format.html { redirect_to rider_ride_path(@ride),
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
        format.html { redirect_to rider_rides_url,
                                  notice: 'Ride was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private

      def rider_ride_params
        ride_params
      end
  end
end
