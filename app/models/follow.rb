class Follow
  include MongoMapper::Document

  key :follower_id , ObjectId
  key :following_id , ObjectId
  timestamps!

  belongs_to :follower , :class_name => "User"
  belongs_to :following , :class_name => "User"
  
end
