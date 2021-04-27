require 'rails_helper'

RSpec.describe MapService do
  describe "class methods" do
    describe ".get_geocode" do
      it "returns an OpenStruct object with the lat and lng as attrabutes" do
        VCR.use_cassette("get_geocode") do
          result = MapService.get_geocode("libby,mt")

          expect(result).to be_a(OpenStruct)
          expect(result.lat).to be_a(Float)
          expect(result.lat).to eq(48.38828)
          expect(result.lng).to be_a(Float)
          expect(result.lng).to eq(-115.55581)
        end
      end
    end

    describe ".get_route" do
      it "returns an OpenStruct object with the travel time lat and lng as attrabutes" do
        VCR.use_cassette("get_route") do
          result = MapService.get_route("denver,co", "libby,mt")

          expect(result).to be_a(OpenStruct)
          expect(result.travel_time).to eq("16 hours, 49 minutes")
          expect(result.offset).to eq(16)
        end
      end

      it "returns an OpenStruct object with the travel time lat and lng as attrabutes" do
        VCR.use_cassette("no_route") do
          result = MapService.get_route("denver,co", "paris,france")

          expect(result).to be_a(OpenStruct)
          expect(result.travel_time).to eq("impossible")
          expect(result.offset).to eq(nil)
        end
      end
    end
  end
end
