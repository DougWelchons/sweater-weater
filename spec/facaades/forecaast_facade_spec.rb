require 'rails_helper'

RSpec.describe ForecastFacade do
  describe "class methods" do
    describe ".get_forecast" do
      describe "Happy Path" do
        it "returns an OpenStruct object for a valid location" do
          VCR.use_cassette('get_valid_location') do
            params = {location: "libby,mt"}

            result = ForecastFacade.get_forecast(params)

            expect(result).to be_a(OpenStruct)
            expect(result.current_weather).to be_a(Hash)
            expect(result.current_weather.keys).to eq([:datetime, :sunrise, :sunset, :temperature, :feels_like, :humidity, :uvi, :visibility, :conditions, :icon])
            expect(result.daily_weather).to be_a(Array)
            expect(result.daily_weather.first).to be_a(Hash)
            expect(result.daily_weather.first.keys).to eq([:date, :sunrise, :sunset, :max_temp, :min_temp, :conditions, :icon])
            expect(result.hourly_weather).to be_a(Array)
            expect(result.hourly_weather.first).to be_a(Hash)
            expect(result.hourly_weather.first.keys).to eq([:time, :temperature, :conditions, :icon])
          end
        end
      end

      describe "Sad Path and Edge Case" do
        it "returns an error OpenStruct object if no origin provided" do
          params = {}

          result = ForecastFacade.get_forecast(params)

          expect(result).to be_a(OpenStruct)
          expect(result.errors).to eq(["Location required"])
        end

        it "returns an OpenStruct object with an array of errors if more then one error" do
          User.create!(email: "email@domain.com", password: "password", password_confirmation: "password", api_key: "api_key")
          params = {location: ""}

          result = ForecastFacade.get_forecast(params)

          expect(result).to be_a(OpenStruct)
          expect(result.errors).to eq(["Location cannot be blank"])
        end
      end
    end
  end
end
