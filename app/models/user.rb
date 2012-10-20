class User
  include MongoMapper::Document
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable, :lockable, :timeoutable, :omniauthable
         
  #devise :encryptable, :encryptor => :bcrypt

  ## Database authenticatable
  key :email,              String, :default => ""
  key :encrypted_password, String, :default => ""

  validates_presence_of :email
  validates_presence_of :encrypted_password
  
  ## Recoverable
  key :reset_password_token,   String
  key :reset_password_sent_at, DateTime

  ## Rememberable
  key :remember_created_at, DateTime

  ## Trackable
  key :sign_in_count,      Integer, :default => 0
  key :current_sign_in_at, DateTime
  key :last_sign_in_at,    DateTime
  key :current_sign_in_ip, String
  key :last_sign_in_ip,    String

  ## Confirmable
  key :confirmation_token,   String
  key :confirmed_at,         DateTime
  key :confirmation_sent_at, DateTime

  ## Lockable
  key :failed_attempts, Integer, :default => 0 # Only if lock strategy is :failed_attempts
  key :unlock_token,    String # Only if unlock strategy is :email or :both
  key :locked_at,       DateTime

  ## Token authenticatable
  key :authentication_token, String

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

  key :name , String
  key :role , Array , :default => ["user"]
  PROVIDERS.each do |provider|
    PROVIDER_FIELDS.each do |field|
      class_eval <<-KEYS, __FILE__, __LINE__ + 1
        key "#{provider}_#{field}".to_sym, String, :default => ''
      KEYS
    end
  end
  key :active , Boolean , :default => true
  key :is_private , Boolean , :default => false

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

  many :followers, :dependent => :destroy, :foreign_key => "follower_id", :class_name => "Follow"
  many :followings, :dependent => :destroy, :foreign_key => "following_id", :class_name => "Follow"
  many :follow_requests, :dependent => :destroy, :foreign_key => "following_id", :class_name => "FollowRequest"

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

  def follow(following_users_id)
    return false unless Util.is_ObjectId(following_users_id)
    return follow_(following_users_id) unless !User.is_profile_private(following_users_id)
    return FollowRequest.add_request(self.id,following_users_id)
  end

  def unfollow(following_users_id)
    return false unless Util.is_ObjectId(following_users_id)
    return unfollow_(following_users_id)
  end

  def remove_follower(follower_id)
    return false unless Util.is_ObjectId(follower_id)
    return remove_follower_(follower_id)
  end

  def accept(follow_request_id)
    return false unless Util.is_ObjectId(follow_request_id)
    return ( FollowRequest.accept(follow_request_id) and add_follower_by_request(follow_request_id) )
  end

  def add_follower_by_request(follow_request)
    return false unless Util.is_ObjectId(follow_request_id)
    return add_follower_  FollowRequest.initiator(follow_request)
  end

  def decline(follow_request_id)
    return false unless Util.is_ObjectId(follow_request_id)
    return FollowRequest.decline(follow_request_id)
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

  def follow_(user_id)
    return Util.is_What self.followers.create!(:following_id => user_id), "Follow"
  end

  def unfollow_(user_id)
    return ( self.followers.find_by_following_id(user_id).try(:destroy) || false )
  end

  def remove_follower_(user_id)
    return ( self.followings.find_by_follower_id(user_id).try(:destroy) || false )
  end

  def add_follower_(user_id)
    return Util.is_What self.followings.create!(:follower_id => user_id), "Follow"
  end

end

