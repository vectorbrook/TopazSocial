class ServiceCase
  include Mongoid::Document
  include Mongoid::Timestamps
  include Noteable
  include Enablable

  field :name , :type => String
  field :description , :type => String
  field :type , :type => Integer
  field :priority , :type => Integer
  field :impact , :type => String
  field :status , :type => String
  field :solution , :type => String
  field :created_by, :type => BSON::ObjectId
  field :assigned_to, :type => BSON::ObjectId
  field :customer_account_id, :type => BSON::ObjectId
  field :customer_contact_id, :type => BSON::ObjectId
  field :visible_to, :type => Array
  field :tags, :type => Array

  belongs_to :forum_post
  belongs_to :customer_account
  embeds_many :service_case_logs
  embeds_many :service_case_interactions

  scope :assigned, ->{ where(:assigned_to.ne => nil) }
  scope :unassigned, ->{ where(:assigned_to => nil) }

  cattr_reader :per_page
  @@per_page = 3

  def self.my_service_cases(user_id)
    return [] unless Util.is_ObjectId(user_id)
    return ServiceCase.where(:assigned_to => user_id)
  end

  def assign_to(user_id)
    return false unless Util.is_What(user_id,"String")
    return assign_to_(user_id)
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
