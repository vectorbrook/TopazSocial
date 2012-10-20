class CustomerContact
  include MongoMapper::EmbeddedDocument
  include Noteable
  include Enablable
 
  key :first_name, String , :required => true
  key :last_name, String , :required => true
  key :phone_number1, String , :required => true
  key :phone_number2, String 
  key :phone_number3, String 
  key :fax_number, String 
  key :email_addr, String , :required => true
  key :sell_to, Boolean 
  key :ship_to, Boolean 
  key :bill_to, Boolean
  key :user_id, ObjectId
  #key :customer_site_id , ObjectId, :required => true
  #key :notes,  Array, :typecast => 'String'
  #key :enabled, Boolean, :required => true 

  timestamps!

  embedded_in :customer_site
  belongs_to :user
  
  after_create :create_user
  
  def full_name
    self.first_name + " " + self.last_name
  end
  
  def full_details
    (%w[phone_number1 phone_number2 phone_number3 fax_number email_addr].collect { |a| Util.concatify_attribute(self.send(a.to_sym)) }.join)[2...2000]
  end
  
  protected
  
  def create_user
    contact_user = User.new
    contact_user.name = self.full_name
    contact_user.email = self.email_addr
    contact_user.role = ["user","customer"]
    contact_user.save(:validate => false)
    self.user_id = contact_user.id
    self.save
  end
    
end
