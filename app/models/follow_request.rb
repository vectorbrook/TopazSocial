class FollowRequest
  include MongoMapper::Document

  key :follower_id , ObjectId , :required => true
  key :following_id , ObjectId , :required => true
  key :status , String , :default => "open"
  timestamps!

  belongs_to :follower , :class_name => "User" 
  belongs_to :following , :class_name => "User"
  
  def self.add_request(from_user ,for_user)
    return false unless ( Util.is_ObjectId from_user and Util.is_ObjectId for_user )
    return Util.is_What FollowRequest.create!( :follower_id => from_user , :following_id => for_user ), "FollowRequest"
  end
  
  def self.initiator(id_)
    return ( FollowRequest.find( id_) ).try(:follower_id)
  end
  
  def self.accept(id_)
    return ( FollowRequest.find( id_) ).try(:change_status,"accept") || false
  end
  
  def self.decline
    return ( FollowRequest.find( id_) ).try(:change_status,"decline") || false
  end
  
  protected
  
  def change_status(type)
    if type == "accept"
      self.status = "accepted"      
    else
      self.status = "declined"
    end
    return self.save!
  end
  
end
