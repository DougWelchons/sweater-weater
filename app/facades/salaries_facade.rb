class SalariesFacade

  def self.get_salaries(destination)
    cords = MapService.get_geocode(destination)
    weather = WeatherService.get_current_weather(cords)
    salaries = SalariesService.get_salaries(destination)
    return salaries if salaries.error
    OpenStruct.new({id: nil, destination: destination, forecast: {summary: weather.summary, temperature: weather.temperature}, salaries: salaries.salaries})
  end
end
