class BackgroundsFacade
  # extend Validatable

  def self.get_background(params)
    errors = validate_required_param(params, [:location])
    if errors.any?
      OpenStruct.new({errors: errors})
    else
      ImageService.get_image(params[:location])
    end
  end

  def self.validate_required_param(params, required_keys)
    required_keys.map do |element|
      next "#{element.to_s.capitalize} required" unless params[element]
      "#{element.to_s.capitalize} cannot be blank" if params[element].blank?
    end.compact
  end
end
