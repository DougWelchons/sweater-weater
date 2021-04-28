class ApiService

  def self.make_api_call(url)
    response = connection.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.connection
    Faraday.new(url: base_url)
  end

  def self.base_url
    raise StandardError.new "self.base_url, must be defined in child class!"
  end
end
