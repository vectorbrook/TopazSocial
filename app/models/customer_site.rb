class CustomerSite
  include Mongoid::Document
  include Mongoid::Timestamps
  #include Noteable
  include Enablable

  field :name, :type => String
  field :description, :type => String
  field :address_line1, :type => String
  field :address_line2, :type => String
  field :city, :type => String
  field :state, :type => String
  field :country, :type => String, :default => "US"
  field :zipcode, :type => String
  field :customer_account_id , :type => Moped::BSON::ObjectId

  attr_accessor :temp

  embeds_many :customer_contacts
  embedded_in :customer_account

  def full_address
    (%w[address_line1 address_line2 city state country zipcode].collect { |a| Util.concatify_attribute(self.send(a.to_sym)) }.join)[2...2000]
  end

  protected


end
