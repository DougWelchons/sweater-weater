require 'rails_helper'

RSpec.describe "api/v1/backgrounds endpoint" do
  describe "Happy Path" do
    it "returns an image url and relevent info" do
      VCR.use_cassette('backgrounds_request') do
        location = "libby,mt"
        get "/api/v1/backgrounds?location=#{location}"
        body = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(200)
        expect(body).to be_a(Hash)
        expect(body.keys).to eq([:data])
        expect(body[:data]).to be_a(Hash)
        expect(body[:data].keys).to eq([:id, :type, :attributes])
        expect(body[:data][:type]).to eq("image")
        expect(body[:data][:id]).to eq(nil)
        expect(body[:data][:attributes]).to be_a(Hash)
        expect(body[:data][:attributes].keys).to eq([:image])
        expect(body[:data][:attributes][:image]).to be_a(Hash)
        expect(body[:data][:attributes][:image].keys).to eq([:location, :image_url, :credit])
        expect(body[:data][:attributes][:image][:location]).to eq(location)
        expect(body[:data][:attributes][:image][:image_url]).to eq("https://live.staticflickr.com/4894/45975335341_a0651a3f92.jpg")
        expect(body[:data][:attributes][:image][:credit]).to be_a(Hash)
        expect(body[:data][:attributes][:image][:credit].keys).to eq([:source, :auther])
        expect(body[:data][:attributes][:image][:credit][:source]).to eq("flickr.com")
        expect(body[:data][:attributes][:image][:credit][:auther]).to eq("ID:129652149@N03")
      end
    end
  end

  describe "Sad Path" do

  end

  describe "Edge Case" do

  end
end
