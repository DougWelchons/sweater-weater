class SalariesService

  def self.get_salaries(destination)
    result = make_api_call("/api/urban_areas/slug%3A#{destination}/salaries")
    jobs = ["Data Analyst",
            "Data Scientist",
            "Mobile Developer",
            "QA Engineer",
            "Software Engineer",
            "Systems Administrator",
            "Web Developer"]
    salaries = result[:salaries].find_all do |job|
      jobs.include?(job[:job][:title])
    end
    cleaned_salaries = salaries.map do |salary|
      {
        title: salary[:job][:title],
        min: number_to_currency(salary[:salary_percentiles][:percentile_25]),
        max: number_to_currency(salary[:salary_percentiles][:percentile_75])
      }
    end
    OpenStruct.new(salaries: cleaned_salaries)
    require "pry"; binding.pry
  end

  def self.make_api_call(url)
    response = connection.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.connection
    Faraday.new(url: ENV['TP-SALARIES-API'])
  end
end
