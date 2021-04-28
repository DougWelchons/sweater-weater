require 'rails_helper'

RSpec.describe RoadTripFacade do
  describe "class methods" do
    describe ".get_route" do
      describe "Happy Path" do
        it "returns an OpenStruct object for a valid route" do
          VCR.use_cassette('get_valid_route') do
            User.create!(email: "email@domain.com", password: "password", password_confirmation: "password", api_key: "api_key")
            params = {origin: "libby,mt", destination: "denver,co", api_key: "api_key"}

            result = RoadTripFacade.get_route(params)

            expect(result).to be_a(OpenStruct)
            expect(result.start_city).to eq("libby,mt")
            expect(result.end_city).to eq("denver,co")
            expect(result.travel_time).to eq("17 hours, 31 minutes")
            expect(result.weather_at_eta).to be_a(Hash)
            expect(result.weather_at_eta.keys).to eq([:temperature, :conditions])
            expect(result.weather_at_eta[:temperature]).to be_a(Float)
            expect(result.weather_at_eta[:conditions]).to be_a(String)
          end
        end

        it "returns an OpenStruct object for a impossible route" do
          VCR.use_cassette('get_impossible_route') do
            User.create!(email: "email@domain.com", password: "password", password_confirmation: "password", api_key: "api_key")
            params = {origin: "libby,mt", destination: "paris,france", api_key: "api_key"}

            result = RoadTripFacade.get_route(params)

            expect(result).to be_a(OpenStruct)
            expect(result.start_city).to eq("libby,mt")
            expect(result.end_city).to eq("paris,france")
            expect(result.travel_time).to eq("impossible")
            expect(result.weather_at_eta).to be_a(Hash)
            expect(result.weather_at_eta.keys).to eq([])
          end
        end
      end

      describe "Sad Path and Edge Case" do
        it "returns an error OpenStruct object if invalid api key" do
          User.create!(email: "email@domain.com", password: "password", password_confirmation: "password", api_key: "api_key")
          params = {origin: "libby,mt", destination: "denver,co", api_key: "invalid_api_key"}

          result = RoadTripFacade.get_route(params)

          expect(result).to be_a(OpenStruct)
          expect(result.errors).to eq("Unautherized user")
        end

        it "returns an error OpenStruct object if no api key provided" do
          User.create!(email: "email@domain.com", password: "password", password_confirmation: "password", api_key: "api_key")
          params = {origin: "libby,mt", destination: "denver,co"}

          result = RoadTripFacade.get_route(params)

          expect(result).to be_a(OpenStruct)
          expect(result.errors).to eq("Unautherized user")
        end

        it "returns an error OpenStruct object if no origin provided" do
          User.create!(email: "email@domain.com", password: "password", password_confirmation: "password", api_key: "api_key")
          params = {destination: "denver,co", api_key: "api_key"}

          result = RoadTripFacade.get_route(params)

          expect(result).to be_a(OpenStruct)
          expect(result.errors).to eq(["Origin required"])
        end

        it "returns an OpenStruct object with an array of errors if more then one error" do
          User.create!(email: "email@domain.com", password: "password", password_confirmation: "password", api_key: "api_key")
          params = {api_key: "api_key"}

          result = RoadTripFacade.get_route(params)

          expect(result).to be_a(OpenStruct)
          expect(result.errors).to eq(["Origin required", "Destination required"])
        end
      end
    end
  end
end
