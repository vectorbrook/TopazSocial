json.array!(@customer_accounts) do |customer_account|
  json.extract! customer_account, :name, :description, :ac_type
  json.url customer_account_url(customer_account, format: :json)
end
