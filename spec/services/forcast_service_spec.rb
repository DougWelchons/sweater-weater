require "rails_helper"

RSpec.describe WeatherService do
  describe "class methods" do
    describe ".get_weather" do
      it "returns and OpenStruct object with current daily, and hourly weather" do
        VCR.use_cassette("get_weather") do
          cords = OpenStruct.new({lat: 48.38828, lng: -115.55581})
          result = WeatherService.get_weather(cords)

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

    describe ".get_current_weather" do
      it "returns and OpenStruct object with current daily, and hourly weather" do
        cords = OpenStruct.new({lat: 48.38828, lng: -115.55581})
        result = WeatherService.get_current_weather(cords)

        expect(result).to be_a(OpenStruct)
        expect(result.summary).to be_a(String)
        expect(result.temperature).to be_a(String)
      end
    end
  end
end
