class ForecastFacade

  def self.get_forecast(params)
    errors = validate_required_param(params, [:location])
    if errors.any?
      OpenStruct.new({errors: errors})
    else
      cords = MapService.get_geocode(params[:location])
      WeatherService.get_weather(cords)
    end
  end

  def self.validate_required_param(params, required_keys)
    required_keys.map do |element|
      next "#{element.to_s.capitalize} required" unless params[element]
      "#{element.to_s.capitalize} cannot be blank" if params[element].blank?
    end.compact
  end
end
