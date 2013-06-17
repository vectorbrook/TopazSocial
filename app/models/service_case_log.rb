class ServiceCaseLog
  include Mongoid::Document

  embedded_in :service_case

  field :log_text, :type => String
  field :created_at , :type => DateTime
  field :user_id, :type => Moped::BSON::ObjectId

end
