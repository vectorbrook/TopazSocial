class ServiceCaseLog
  include MongoMapper::EmbeddedDocument
  
  key :log_text, String, :required => true
  key :created_at , DateTime
  key :user_id, ObjectId, :required => true
  
end
