require 'rails_helper'

RSpec.describe BackgroundsFacade do
  describe "class methods" do
    describe ".get_background" do
      describe "Happy Path" do
        it "returns an OpenStruct object for a valid location" do
          VCR.use_cassette('get_image') do
            params = {location: "libby,mt"}

            result = BackgroundsFacade.get_background(params)

            expect(result).to be_a(OpenStruct)
            expect(result.image).to be_a(Hash)
            expect(result.image.keys).to eq([:location, :image_url, :credit])
            expect(result.image[:location]).to eq("libby,mt")
            expect(result.image[:image_url]).to eq("https://live.staticflickr.com/4894/45975335341_a0651a3f92.jpg")
            expect(result.image[:credit]).to be_a(Hash)
            expect(result.image[:credit].keys).to eq([:source, :auther])
            expect(result.image[:credit][:source]).to eq("flickr.com")
            expect(result.image[:credit][:auther]).to eq("ID:129652149@N03")
          end
        end
      end

      describe "Sad Path and Edge Case" do
        it "returns an error OpenStruct object if no origin provided" do
          params = {}

          result = BackgroundsFacade.get_background(params)

          expect(result).to be_a(OpenStruct)
          expect(result.errors).to eq(["Location required"])
        end

        it "returns an OpenStruct object with an array of errors if more then one error" do
          User.create!(email: "email@domain.com", password: "password", password_confirmation: "password", api_key: "api_key")
          params = {location: ""}

          result = BackgroundsFacade.get_background(params)

          expect(result).to be_a(OpenStruct)
          expect(result.errors).to eq(["Location cannot be blank"])
        end
      end
    end
  end
end
