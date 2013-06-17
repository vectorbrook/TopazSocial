class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable, :confirmable, :timeoutable, :lockable, :omniauthable

  ## Database authenticatable
  field :name
  validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :provider, :uid
  field :provider, :type => String
  field :uid, :type => String
 

  
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
  
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
   field :confirmation_token,   :type => String
   field :confirmed_at,         :type => Time
   field :confirmation_sent_at, :type => Time
   field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
   field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
   field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
   field :locked_at,       :type => Time

  ## Token authenticatable
   field :authentication_token, :type => String
   
  cattr_accessor :private_profiles

  def self.initialize_private_profiles
    @@private_profiles ||= User.where(:is_private => true).all.collect(&:id)
  end

  def self.is_profile_private(user_id)
    User.initialize_private_profiles
    return false unless Util.is_ObjectId user_id
    return User.private_profiles.include? user_id
  end

  def self.add_private_profile(user_id)
    return true if ( User.is_profile_private user_id )
    return Util.is_What( User.private_profiles << user_id ) , "Array"
  end

  def self.remove_private_profile(user_id)
    return true if !( User.is_profile_private user_id )
    return Util.is_What( User.private_profiles.delete user_id ) , "String"
  end

  before_save :check_role
  after_save :update_private_profiles

  PROVIDERS = %w(twitter)
  PROVIDER_FIELDS = %w(uid profile_url token secret)

  field :name , :type => String
  field :role , :type => Array , :default => ["user"]
  

  PROVIDERS.each do |provider|
    PROVIDER_FIELDS.each do |field|
      class_eval <<-KEYS, __FILE__, __LINE__ + 1
        field "#{provider}_#{field}".to_sym, :type => String, :default => ''
      KEYS
    end
  end
  field :active , :type => Boolean , :default => true
  field :is_private , :type => Boolean , :default => false

  attr_accessor  :old_password, :new_password , :new_password_confirmation, :role_arr
  attr_accessible :password, :password_confirmation, :email, :name, :is_private, :role, :role_arr, *(PROVIDERS).map { |p| ["#{p}_uid".to_sym, "#{p}_profile_url".to_sym] }.flatten

  PROVIDERS.each do |p|
    PROVIDER_FIELDS.each do |f|
      class_eval <<-VALIDATIONS, __FILE__, __LINE__ + 1
        validates_uniqueness_of "#{p}_#{f}".to_sym, :if => "#{p}_#{f} != nil and !#{p}_#{f}.blank?"
      VALIDATIONS
    end
  end
  
  
  has_one :customer_contact


  scope :employees , where(:role => "employee")
  scope :non_employees , where(:role => (["user"]))
  scope :prospects , where(:role => "prospect")
  scope :customers , where(:role => "customer")
  scope :active , where(:active => true)

  (ALL_ROLES - ["user"]).each do |role|
    class_eval <<-METHODS, __FILE__, __LINE__ + 1
       def is_#{role}?
        return self.role.include? "#{role}"
      end
     METHODS
   end
  
   def self.create_with_omniauth(auth)
    password = Util.generate_alphanumeric_string
    User.create!(:name => auth["info"]["name"] , "#{auth['provider']}_uid".to_sym => auth["uid"] , "#{auth['provider']}_profile_url".to_sym => auth["info"]["urls"]["#{auth["provider"]}".camelize], "#{auth['provider']}_token".to_sym => auth["credentials"]["token"] ,"#{auth['provider']}_secret".to_sym => auth["credentials"]["secret"] ,:email => "u#{Util.generate_alphanumeric_string(3) + Time.now.to_i.to_s}@ts1.com" , :password => password , :password_confirmation => password , :confirmed_at => Time.now , :role => ["user"])
  end

  def am_i_public?
    return !self.is_private
  end

  def can_clear_provider_account?
    is_employee? or (PROVIDERS.map { |p| [ self.send("#{p}_uid".to_sym) && !self.send("#{p}_uid".to_sym).empty? ] }.flatten).count(true) > 1
  end

  def confirmation_required?
    (employee_not_admin) && super
  end

  def assigned_service_cases
    return [] unless self.is_employee?
    return ServiceCase.my_service_cases(self.id)
  end

  def self.verify_id(id)
    return Util.is_What( User.find(id) , "User")
  end

  # new function to set the password without knowing the current password used in our confirmation controller.
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end
  # new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

  # new function to provide access to protected method unless_confirmed
  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

  def password_required?
    # Password is required if it is being set, but not for new records
    if !persisted?
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end
  
  def twitter_client
    @twitter_client = Twitter::Client.new(:oauth_token => self.twitter_token,:oauth_token_secret => self.twitter_secret)
  end

  protected

  def employee_not_admin
    @is_employee_not_admin ||= ( (self.role.include? "employee" or self.role.include? "customer" or self.role.include? "prospect")  and !self.role.include? "admin" )
  end

  def check_role
    self.role.delete_if { |r| r.blank? }
  end

  def update_private_profiles
    if self.is_private
      User.add_private_profile self.id
    else
      User.remove_private_profile self.id
    end
  end

end
