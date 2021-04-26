require 'rails_helper'

RSpec.describe SalariesService do
  describe "class methods" do
    describe ".get_salaries" do
      it "returns an OpenStruct object with the proper salaries" do
        result = SalariesService.get_salaries("denver")

        expect(result).to be_a(OpenStruct)
        expect(result.salaries).to be_a(Array)
        expect(result.salaries.count).to eq(7)
        expect(result.salaries.first).to be_a(Hash)
        expect(result.salaries.first.keys).to eq([:title, :min, :max])
        expect(result.salaries.first[:title]).to be_a(String)
        expect(result.salaries.first[:min]).to be_a(String)
        expect(result.salaries.first[:max]).to be_a(String)
      end

      it "returns an error if location cannot be found" do
        result = SalariesService.get_salaries("kdsfhadskh")

        expect(result).to be_a(OpenStruct)
        expect(result.error).to eq("Destination could not be found")
      end
    end
  end
end
