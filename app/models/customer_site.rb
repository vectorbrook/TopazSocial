class CustomerSite
  include MongoMapper::Document
  include Noteable
  include Enablable
 
  key :name, String, :required => true  
  key :description, String
  key :address_line1, String , :required => true  
  key :address_line2, String 
  key :city, String , :required => true  
  key :state, String , :required => true  
  key :country, String , :required => true  , :default => "US"
  key :zipcode, String, :required => true  
  key :customer_account_id , ObjectId
  #key :notes,  Array, :typecast => 'String'
  #key :enabled, Boolean, :required => true 
  
  attr_accessor :temp

  timestamps!

  many :customer_contacts
  belongs_to :customer_account
  
  def full_address
    (%w[address_line1 address_line2 city state country zipcode].collect { |a| Util.concatify_attribute(self.send(a.to_sym)) }.join)[2...2000]
  end
  
  protected
  
  
end
