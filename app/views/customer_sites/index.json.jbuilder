json.array!(@customer_sites) do |customer_site|
  json.extract! customer_site, :name, :description, :address_line1, :address_line2, :city, :state, :country, :zipcode, :customer_account_id
  json.url customer_site_url(customer_site, format: :json)
end
