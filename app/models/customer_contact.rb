class CustomerContact
  include Mongoid::Document
  include Mongoid::Timestamps
  include Noteable
  include Enablable

  field :first_name, :type => String
  field :last_name, :type => String
  field :phone_number1, :type => String
  field :phone_number2, :type => String
  field :phone_number3, :type => String
  field :fax_number, :type => String
  field :email_addr, :type => String
  field :sell_to, :type => Boolean
  field :ship_to, :type => Boolean
  field :bill_to, :type => Boolean
  field :user_id, :type => Moped::BSON::ObjectId

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
