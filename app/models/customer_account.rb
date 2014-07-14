class CustomerAccount
  include Mongoid::Document
  
  field :name, type: String
  field :description, type: String
  field :ac_type, type: String
  
  embeds_many :customer_sites
  embeds_many :customer_contacts
  
  cattr_reader :per_page
  @@per_page = 3
end
