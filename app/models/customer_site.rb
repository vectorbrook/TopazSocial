class CustomerSite
  include Mongoid::Document
  
  field :name, type: String
  field :description, type: String
  field :address_line1, type: String
  field :address_line2, type: String
  field :city, type: String
  field :state, type: String
  field :country, type: String, :default => "US"
  field :zipcode, type: String
  
  embeds_many :customer_contacts
  embedded_in :customer_account
  
  cattr_reader :per_page
  @@per_page = 3
end
