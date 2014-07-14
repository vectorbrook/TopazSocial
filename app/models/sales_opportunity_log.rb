class SalesOpportunityLog
  include Mongoid::Document
  
  field :log_text, :type => String
  field :created_at , :type => DateTime
  field :user_id, :type => BSON::ObjectId
  
  embedded_in :sales_opportunity
  belongs_to :user

end
