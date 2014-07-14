class ForumPost
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :body, type: String
  field :description, type: String
  field :user_id, type: BSON::ObjectId
  field :status, type: String
  field :sentiment, type: String

  embedded_in :forum_topic
  has_one :service_case
  belongs_to :user
  
  cattr_reader :per_page
  @@per_page = 3
end
