class ImageService

  def self.get_image(location)
    response = make_api_call("?method=flickr.photos.search&api_key=#{ENV['FR-KEY']}&text=#{location}&format=json&nojsoncallback=1")
    photo = response[:photos][:photo].first
    photo_url = "https://live.staticflickr.com/#{photo[:server]}/#{photo[:id]}_#{photo[:secret]}.jpg"
    OpenStruct.new({id: nil, image: {location: location, image_url: photo_url, credit: {source: "flickr.com", auther: "ID:#{photo[:owner]}"}}})
  end

  def self.make_api_call(url)
    response = connection.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.connection
    Faraday.new(url: ENV['FR-SEARCH-API'])
  end
end
