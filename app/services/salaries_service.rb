class SalariesService

  def self.get_salaries(destination)
    result = make_api_call(/slug%3Adenver/salaries)
  end

  def self.make_api_call(url)
    response = connection.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.connection
    Faraday.new(url: ENV['TP-SALARIES-API'])
  end
end
