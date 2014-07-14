class CustomerContact
  include Mongoid::Document
  
  field :first_name, type: String
  field :last_name, type: String
  field :phone_number1, type: String
  field :phone_number2, type: String
  field :phone_number3, type: String
  field :fax_number, type: String
  field :email_addr, type: String
  field :sell_to, type: Boolean
  field :ship_to, type: Boolean
  field :bill_to, type: Boolean
  field :user_id, type: BSON::ObjectId
  
  embedded_in :customer_site
  belongs_to :user
  
  cattr_reader :per_page
  @@per_page = 3
end
