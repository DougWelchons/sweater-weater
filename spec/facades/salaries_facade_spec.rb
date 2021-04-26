require 'rails_helper'

RSpec.describe SalariesFacade do
  describe "class methods" do
    describe ".get_salaries" do
      it "returns an openstruct object with nessisary info" do
        destination = "denver"
        result = SalariesFacade.get_salaries(destination)

        expect(result).to be_a(OpenStruct)
        expect(result.id).to eq(nil)
        expect(result.destination).to eq(destination)
        expect(result.id).to eq(nil)
        expect(result.forecast).to be_a(Hash)
        expect(result.forecast.keys).to eq([:summary, :temperature])
        expect(result.forecast[:summary]).to be_a(String)
        expect(result.forecast[:temperature]).to be_a(String)
        expect(result.salaries).to be_a(Array)
        expect(result.salaries.count).to eq(7)
        expect(result.salaries.first).to be_a(Hash)
        expect(result.salaries.first.keys).to eq([:title, :min, :max])
        expect(result.salaries.first[:title]).to be_a(String)
        expect(result.salaries.first[:min]).to be_a(String)
        expect(result.salaries.first[:max]).to be_a(String)
      end
    end
  end
end
