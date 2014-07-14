class SalesLeadInteraction
  include Mongoid::Document 

  field :interaction_text, :type => String
  field :created_at , :type => DateTime
  field :user_id, :type => BSON::ObjectId
  
  embedded_in :sales_lead
  belongs_to :user

end
