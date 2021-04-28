class ImageService < ApiService

  def self.get_image(location)
    response = make_api_call("?method=flickr.photos.search&api_key=#{ENV['FR-KEY']}&text=#{location}&format=json&nojsoncallback=1")

    return OpenStruct.new({errors: "No images found"}) if response[:photos][:total] == "0"

    photo = response[:photos][:photo].first
    photo_url = "https://live.staticflickr.com/#{photo[:server]}/#{photo[:id]}_#{photo[:secret]}.jpg"

    OpenStruct.new({
                    id: nil,
                    image: {
                            location: location,
                            image_url: photo_url,
                            credit: {
                                      source: "flickr.com",
                                      auther: "ID:#{photo[:owner]}"
                                    }
                            }
                    })
  end

  def self.base_url
    ENV['FR-SEARCH-API']
  end
end
