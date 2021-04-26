require "rails_helper"

RSpec.describe "app/v1/salaries endpoint" do
  describe "Happy Path" do
    it "returns a 200 response with relevant data" do
      destination = "denver"
      get "/api/v1/salaries?destination=#{destination}"
      body = JSON.parse(response.body, symbolize_names: true)


      expect(response.status).to eq(200)
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:data])
      expect(body[:data]).to be_a(Hash)
      expect(body[:data].keys).to eq([:id, :type, :attributes])
      expect(body[:data][:id]).to eq(nil)
      expect(body[:data][:type]).to eq("salaries")
      expect(body[:data][:attributes]).to be_a(Hash)
      expect(body[:data][:attributes].keys).to eq([:destination, :forecast, :salaries])
      expect(body[:data][:attributes][:destination]).to eq(destination)
      expect(body[:data][:attributes][:forcast]).to be_a(Hash)
      expect(body[:data][:attributes][:forcast].keys).to eq([:summary, :temperature])
      expect(body[:data][:attributes][:forcast][:summary]).to be_a(String)
      expect(body[:data][:attributes][:forcast][:temperature]).to be_a(String)
      expect(body[:data][:attributes][:salaries]).to be_a(Array)
      expect(body[:data][:attributes][:salaries].count).to eq(7)
      expect(body[:data][:attributes][:salaries].first).to be_a(Hash)
      expect(body[:data][:attributes][:salaries].first.keys).to eq([:title, :min, :max])
      expect(body[:data][:attributes][:salaries].first[:title]).to be_a(String)
      expect(body[:data][:attributes][:salaries].first[:min]).to be_a(String)
      expect(body[:data][:attributes][:salaries].first[:max]).to be_a(String)
    end
  end
end
