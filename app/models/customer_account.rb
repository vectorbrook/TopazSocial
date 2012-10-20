class CustomerAccount
  include MongoMapper::Document
  #include Noteable
  include Enablable
 
  key :name, String, :required => true 
  key :description, String 
  key :ac_type, String

  timestamps!

  many :customer_sites
  many :customer_contacts , :through => :customer_sites
  
  cattr_reader :per_page
  @@per_page = 3
  
  scope :active , where(:enabled => true)
  
end
