class ServiceCase
  include MongoMapper::Document
  include Noteable
  include Enablable
  
  key :name , String, :required => true
  key :description , String, :required => true
  key :type , Integer
  key :priority , Integer, :required => true , :in => SERVICECASE_PRIORITIES #%w[Critical Feature Important High Normal Low]    # or case_severity
  key :impact , String
  key :status , String, :required => true , :in => SERVICECASE_STATUSES
  key :solution , String
  key :created_by, ObjectId  , :required => true
  key :assigned_to, ObjectId
  key :customer_account_id, ObjectId , :required => true
  key :customer_contact_id, ObjectId
  key :visible_to, Array, :typecast => 'ObjectId'
  key :tags, Array, :typecast => 'String'

  timestamps!

  belongs_to :customer_account
  many :service_case_logs
  
  scope :assigned, where(:assigned_to.ne => nil)
  scope :unassigned, where(:assigned_to => nil)
  
  
  #before_save :make_log_entry
  
  cattr_reader :per_page
  @@per_page = 3
  
  def self.my_service_cases(user_id)
    return [] unless Util.is_ObjectId(user_id)
    return ServiceCase.find_all_by_assigned_to(user_id)
  end
  
  def assign_to(user_id)
    return false unless Util.is_What(user_id,"String")
    return assign_to_(user_id)
  end
  
  def interactions
    Interaction.all(:context => "ServiceCase", :context_id => id)
  end
  
  def assigned?
    self.assigned_to != nil
  end
  
  def assigned_user_name(user_id)
    u = User.find(user_id)
    u.name
  end
    
  
  protected
  
  def make_log_entry
    self.service_case_logs.build(:log_text => self.changes.to_a , :created_at => Time.now)
  end
  
  def assign_to_(user_id)
    if User.verify_id(user_id)
      self.assigned_to = (User.find user_id).id
      self.status = "Open"
      return true
    end
    return false
  end
  
end
