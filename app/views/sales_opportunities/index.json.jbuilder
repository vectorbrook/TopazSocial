json.array!(@sales_opportunities) do |servic|
  json.(servic, :name, :description, :type, :status, :solution)
  json.url sales_opportunities_url(servic, format: :json)
  json._id servic.id.to_s
end
