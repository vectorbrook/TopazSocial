class Interaction
  include Mongoid::Document
  include Mongoid::Timestamps
  include Enablable
  #include Approvable

  field :body, :type => String
  field :body_html, :type => String
  field :description, :type => String
  field :type, :type => String, :default => "Generic"
  field :status, :type => String, :default => "NA"
  field :sentiment, :type => String, :default => NEUTRAL
  field :solution, :type => String
  field :context_id, :type => Moped::BSON::ObjectId
  field :context, :type => String
  field :user_id, :type => Moped::BSON::ObjectId
  field :approved, :type => Boolean
  field :approved_by, :type => Moped::BSON::ObjectId
  field :parent_context_id, :type => Moped::BSON::ObjectId
  field :parent_context, :type => String

  NameMapping = {"ForumTopic" => "Post","ServiceCase" => "Case Interaction"}

end
