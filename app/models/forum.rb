class Forum
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, type: String
  field :description, type: String
  field :category, type: String
  field :topics_count, type: Integer
  field :posts_count, type: Integer
  field :position, type: Integer
  field :last_post_created_at, type: Time
  field :last_post_created_by, type: String
  field :hits, type: Integer
  
  embeds_many :forum_topics
  
  cattr_reader :per_page
  @@per_page = 3
end
