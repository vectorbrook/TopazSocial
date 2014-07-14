json.array!(@service_cases) do |servic|
  json.(servic, :name, :description, :type, :priority, :impact, :status, :solution)
  json.url service_cases_url(servic, format: :json)
  json._id servic.id.to_s
end
