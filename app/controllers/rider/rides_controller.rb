module Rider
  class RidesController < ApplicationController
    include RideManager

    # GET /rides
    # GET /rides.json
    def index
      @rides = Ride.all.filter do |ride|
        !ride.driver.nil?
      end
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
      @ride = Ride.new(ride_params)

      respond_to do |format|
        if @ride.save
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
        if @ride.update(ride_params)
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
        format.html { redirect_to rider_rides_url, notice: 'Ride was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end
end
