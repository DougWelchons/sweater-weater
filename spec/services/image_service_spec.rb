require "rails_helper"

RSpec.describe ImageService do
  describe "class methods" do
    describe ".get_image" do
      it "returns an OpenStruct object with the nessiary image data" do
        VCR.use_cassette('get_image') do
          location = "libby,mt"
          result = ImageService.get_image(location)

          expect(result).to be_a(OpenStruct)
          expect(result.image).to be_a(Hash)
          expect(result.image.keys).to eq([:location, :image_url, :credit])
          expect(result.image[:location]).to eq(location)
          expect(result.image[:image_url]).to eq("https://live.staticflickr.com/4894/45975335341_a0651a3f92.jpg")
          expect(result.image[:credit]).to be_a(Hash)
          expect(result.image[:credit].keys).to eq([:source, :auther])
          expect(result.image[:credit][:source]).to eq("flickr.com")
          expect(result.image[:credit][:auther]).to eq("ID:129652149@N03")
        end
      end

      it "returns an error OpenStruct object if no images found" do
        VCR.use_cassette('no_image') do
          location = "ldjkf jkdf alsdkf w-eewr"
          result = ImageService.get_image(location)

          expect(result).to be_a(OpenStruct)
          expect(result.errors).to eq("No images found")
        end
      end
    end
  end
end
