class ServiceCaseInteraction
  include Mongoid::Document 

  field :interaction_text, :type => String
  field :created_at , :type => DateTime
  field :user_id, :type => BSON::ObjectId
  
  embedded_in :service_case
  belongs_to :user

end
