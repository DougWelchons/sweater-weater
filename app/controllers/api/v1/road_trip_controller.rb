class Api::V1::RoadTripController < ApplicationController

  def create
    road_trip = RoadTripFacade.get_route(params)

    if road_trip.errors
      render json: error(road_trip.errors), status: :bad_request
    else
      render json: RoadtripSerializer.new(road_trip), status: :created
    end
  end
end
