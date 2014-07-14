json.array!(@customer_contacts) do |customer_contact|
  json.extract! customer_contact, :first_name, :last_name, :phone_number1, :phone_number2, :phone_number3, :fax_number, :email_addr, :sell_to, :ship_to, :bill_to, :user_id
  json.url customer_contact_url(customer_contact, format: :json)
end
