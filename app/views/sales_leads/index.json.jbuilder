json.array!(@sales_leads) do |servic|
  json.(servic, :first_name, :last_name, :type, :status)
  json.url sales_leads_url(servic, format: :json)
  json._id servic.id.to_s
end
