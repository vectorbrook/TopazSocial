class CustomerAccount
  include Mongoid::Document
  include Mongoid::Timestamps
  #include Noteable
  include Enablable

  field :name, :type => String
  field :description, :type => String
  field :ac_type, :type => String
  attr_accessible :name, :description, :ac_type

  embeds_many :customer_sites
  embeds_many :customer_contacts
  has_many :service_cases
  cattr_reader :per_page
  @@per_page = 3

  scope :active , where(:enabled => true)

end
