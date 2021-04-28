require 'rails_helper'

RSpec.describe "app/v1/road_trip endpoint" do
  describe "Happy Path" do
    it "returns a 200 response with the appropriate data structure" do
      VCR.use_cassette('road_trip') do
        email = "email@domain.com"
        password = "password"
        api_key = "fdsj34h3jh2jhr7ai2p0"
        origin = "denver,co"
        destination = "libby,mt"

        User.create!(email: email, password: password, password_confirmation: password, api_key: api_key)
        headers = {'CONTENT_TYPE' => 'application/json'}
        body = {origin: origin, destination: destination, api_key: api_key}
        post "/api/v1/road_trip", headers: headers, params: body, as: :json
        body = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(201)
        expect(body).to be_a(Hash)
        expect(body.keys).to eq([:data])
        expect(body[:data]).to be_a(Hash)
        expect(body[:data].keys).to eq([:id, :type, :attributes])
        expect(body[:data][:type]).to eq("roadtrip")
        expect(body[:data][:id]).to eq(nil)
        expect(body[:data][:attributes]).to be_a(Hash)
        expect(body[:data][:attributes].keys).to eq([:start_city, :end_city, :travel_time, :weather_at_eta])
        expect(body[:data][:attributes][:start_city]).to eq(origin)
        expect(body[:data][:attributes][:end_city]).to eq(destination)
        expect(body[:data][:attributes][:travel_time]).to eq("17 hours, 3 minutes")
        expect(body[:data][:attributes][:weather_at_eta]).to be_a(Hash)
        expect(body[:data][:attributes][:weather_at_eta].keys).to eq([:temperature, :conditions])
        expect(body[:data][:attributes][:weather_at_eta][:temperature]).to be_a(Float)
        expect(body[:data][:attributes][:weather_at_eta][:conditions]).to be_a(String)
      end
    end

    it "returns a 200 response without weather if trip is impossible" do
      VCR.use_cassette('impossible_road_trip') do
        email = "email@domain.com"
        password = "password"
        api_key = "fdsj34h3jh2jhr7ai2p0"
        origin = "denver,co"
        destination = "paris,france"

        User.create!(email: email, password: password, password_confirmation: password, api_key: api_key)
        headers = {'CONTENT_TYPE' => 'application/json'}
        body = {origin: origin, destination: destination, api_key: api_key}
        post "/api/v1/road_trip", headers: headers, params: body, as: :json
        body = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(201)
        expect(body).to be_a(Hash)
        expect(body.keys).to eq([:data])
        expect(body[:data]).to be_a(Hash)
        expect(body[:data].keys).to eq([:id, :type, :attributes])
        expect(body[:data][:type]).to eq("roadtrip")
        expect(body[:data][:id]).to eq(nil)
        expect(body[:data][:attributes]).to be_a(Hash)
        expect(body[:data][:attributes].keys).to eq([:start_city, :end_city, :travel_time, :weather_at_eta])
        expect(body[:data][:attributes][:start_city]).to eq(origin)
        expect(body[:data][:attributes][:end_city]).to eq(destination)
        expect(body[:data][:attributes][:travel_time]).to eq("impossible")
        expect(body[:data][:attributes][:weather_at_eta]).to be_a(Hash)
        expect(body[:data][:attributes][:weather_at_eta].keys).to eq([])
      end
    end
  end

  describe "Edge Case and Sad path" do
    it "returns a 400 response if no origin is provided" do
      email = "email@domain.com"
      password = "password"
      api_key = "fdsj34h3jh2jhr7ai2p0"
      destination = "paris,france"

      User.create!(email: email, password: password, password_confirmation: password, api_key: api_key)
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {destination: destination, api_key: api_key}
      post "/api/v1/road_trip", headers: headers, params: body, as: :json
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(body[:error]).to eq(["Origin required", "https://github.com/DougWelchons/sweater-weather#endpoint-documentation"])
    end

    it "returns a 400 response if origin is blank" do
      email = "email@domain.com"
      password = "password"
      api_key = "fdsj34h3jh2jhr7ai2p0"
      origin = ""
      destination = "paris,france"

      User.create!(email: email, password: password, password_confirmation: password, api_key: api_key)
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {origin: origin, destination: destination, api_key: api_key}
      post "/api/v1/road_trip", headers: headers, params: body, as: :json
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(body[:error]).to eq(["Origin cannot be blank", "https://github.com/DougWelchons/sweater-weather#endpoint-documentation"])
    end

    it "returns a 400 response if no destination is provided" do
      email = "email@domain.com"
      password = "password"
      api_key = "fdsj34h3jh2jhr7ai2p0"
      origin = "denver,co"

      User.create!(email: email, password: password, password_confirmation: password, api_key: api_key)
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {origin: origin, api_key: api_key}
      post "/api/v1/road_trip", headers: headers, params: body, as: :json
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(body[:error]).to eq(["Destination required", "https://github.com/DougWelchons/sweater-weather#endpoint-documentation"])
    end

    it "returns a 400 response if destination is blank" do
      email = "email@domain.com"
      password = "password"
      api_key = "fdsj34h3jh2jhr7ai2p0"
      origin = "denver,co"
      destination = ""

      User.create!(email: email, password: password, password_confirmation: password, api_key: api_key)
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {origin: origin, destination: destination, api_key: api_key}
      post "/api/v1/road_trip", headers: headers, params: body, as: :json
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(body[:error]).to eq(["Destination cannot be blank", "https://github.com/DougWelchons/sweater-weather#endpoint-documentation"])
    end

    it "returns a 400 response if no api key is provided" do
      email = "email@domain.com"
      password = "password"
      api_key = "fdsj34h3jh2jhr7ai2p0"
      origin = "denver,co"
      destination = "paris,france"

      User.create!(email: email, password: password, password_confirmation: password, api_key: api_key)
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {origin: origin, destination: destination}
      post "/api/v1/road_trip", headers: headers, params: body, as: :json
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(body[:error]).to eq(["Unautherized user", "https://github.com/DougWelchons/sweater-weather#endpoint-documentation"])
    end

    it "returns a 400 response if api key is invalid" do
      email = "email@domain.com"
      password = "password"
      api_key = "fdsj34h3jh2jhr7ai2p0"
      origin = "denver,co"
      destination = "paris,france"

      User.create!(email: email, password: password, password_confirmation: password, api_key: api_key)
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {origin: origin, destination: destination, api_key: "invalid_api_key"}
      post "/api/v1/road_trip", headers: headers, params: body, as: :json
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(body[:error]).to eq(["Unautherized user", "https://github.com/DougWelchons/sweater-weather#endpoint-documentation"])
    end

    it "returns a 400 response if api key is blank" do
      email = "email@domain.com"
      password = "password"
      api_key = "fdsj34h3jh2jhr7ai2p0"
      origin = "denver,co"
      destination = "paris,france"

      User.create!(email: email, password: password, password_confirmation: password, api_key: api_key)
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {origin: origin, destination: destination, api_key: ''}
      post "/api/v1/road_trip", headers: headers, params: body, as: :json
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(body[:error]).to eq(["Unautherized user", "https://github.com/DougWelchons/sweater-weather#endpoint-documentation"])
    end
  end
end
