class Interaction
  include MongoMapper::Document
  include Enablable
  #include Approvable

  key :body, String, :required => true
  key :body_html, String
  key :description, String
  key :type, String, :default => "Generic"
  key :status, String, :default => "NA"
  key :sentiment, String, :default => NEUTRAL
  key :solution, String
  key :context_id, ObjectId, :required => true
  key :context, String, :required => true
  key :user_id, ObjectId, :required => true
  key :approved, Boolean, :default => true
  key :approved_by, ObjectId 

  timestamps!
  
  NameMapping = {"ForumTopic" => "Post","ServiceCase" => "Case Interaction"}
  
end
