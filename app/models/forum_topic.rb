class ForumTopic
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :description, type: String
  field :posts_count, type: Integer
  field :hits, type: Integer
  field :sticky, type: Integer
  field :user_id, type: BSON::ObjectId
  field :last_post_created_at, type: Time
  field :last_post_created_by, type: String

  embedded_in :forum
  embeds_many :forum_posts
  belongs_to :user
  
  cattr_reader :per_page
  @@per_page = 3

end
