require 'rails_helper'

RSpec.describe "api/v1/forecast endpoint", type: :request do
  describe "Happy Path" do
    it "returns a 200 response with the proper data structure" do
      VCR.use_cassette "MQ-api" do
        get "/api/v1/forecast?location=libby,MT"
        body = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(200)
        expect(body).to be_a(Hash)
        expect(body.keys).to eq([:data])
        expect(body[:data]).to be_a(Hash)
        expect(body[:data].keys).to eq([:id, :type, :attributes])
        expect(body[:data][:id]).to eq(nil)
        expect(body[:data][:type]).to eq("forecast")
        expect(body[:data][:attributes]).to be_a(Hash)
        expect(body[:data][:attributes].keys).to eq([:current_weather, :daily_weather, :hourly_weather])
        expect(body[:data][:attributes][:current_weather]).to be_a(Hash)
        expect(body[:data][:attributes][:current_weather].keys).to eq([:datetime, :sunrise, :sunset, :temperature, :feels_like, :humidity, :uvi, :visibility, :conditions, :icon])
        expect(body[:data][:attributes][:daily_weather]).to be_a(Array)
        expect(body[:data][:attributes][:daily_weather].count).to eq(5)
        expect(body[:data][:attributes][:daily_weather].first).to be_a(Hash)
        expect(body[:data][:attributes][:daily_weather].first.keys).to eq([:date, :sunrise, :sunset, :max_temp, :min_temp, :conditions, :icon])
        expect(body[:data][:attributes][:hourly_weather]).to be_a(Array)
        expect(body[:data][:attributes][:hourly_weather].count).to eq(8)
        expect(body[:data][:attributes][:hourly_weather].first.keys).to eq([:time, :temperature, :conditions, :icon])
      end
    end

    it "is case insinsitive"
  end

  describe "Sad Path" do

  end

  describe "Edge Case" do
    it "returns a 400 error if location param is not provided" do
      VCR.use_cassette('forecast_no_location') do
        get "/api/v1/forecast"
        body = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(400)
        expect(body).to eq({:error=>["Location required", "https://github.com/DougWelchons/sweater-weater#endpoint-documentation"]})
      end
    end

    it "returns a 400 error if location is blank" do
      VCR.use_cassette('forecast_location_blank') do
        get "/api/v1/forecast?location="
        body = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(400)
        expect(body).to eq({:error=>["location cannot be blank", "https://github.com/DougWelchons/sweater-weater#endpoint-documentation"]})
      end
    end

    it "returns a 400 error if only a city is provided"

    it "returns a 400 error if only a state is provided"

    it "returns a 400 error if state is not a 2 letter code"

    it "returns a 400 error if city cannot be found"

    it "returns a 400 error if the state is not a proper 2 lettrer code"
  end
end
