# Topaz Social
# Copyright (C) 2011 by Vector Brook
#
#
# This file is part of Topaz Social.
#
# Topaz Social is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Topaz Social is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Topaz Social.  If not, see <http://www.gnu.org/licenses/agpl-3.0.html>.


class User
  include MongoMapper::Document
  include AccessControl
  
  cattr_accessor :private_profiles
  
  def self.initialize_private_profiles
    @@private_profiles ||= User.where(:is_private => true).all.collect(&:id)
  end
  
  def self.is_profile_private(user_id)
    User.initialize_private_profiles
    return false unless Util.is_ObjectId user_id
    return User.private_profiles.include? user_id
  end
  
  def self.add_private_profile(user_id)
    return true if ( User.is_profile_private user_id )
    return Util.is_What( User.private_profiles << user_id ) , "Array"
  end
  
  def self.remove_private_profile(user_id)
    return true if !( User.is_profile_private user_id )
    return Util.is_What( User.private_profiles.delete user_id ) , "String"
  end

  before_save :check_role
  after_save :update_private_profiles

  devise  :database_authenticatable, :lockable, :rememberable, :trackable, :recoverable, :validatable,  :confirmable , :registerable
  
  key :name , String
  key :role , Array , :default => ["user"]
  key :facebook_uid , String
  key :twitter_uid , String
  key :active , Boolean , :default => true
  key :is_private , Boolean , :default => false
  
  attr_accessor  :old_password, :new_password , :new_password_confirmation, :role_arr
  attr_accessible :password, :password_confirmation  , :email, :name , :is_private , :facebook_uid, :twitter_uid , :role , :role_arr
    
  many :followers , :dependent => :destroy , :foreign_key => "follower_id" , :class_name => "Follow"
  many :followings , :dependent => :destroy , :foreign_key => "following_id" , :class_name => "Follow"
  many :follow_requests , :dependent => :destroy , :foreign_key => "following_id" , :class_name => "FollowRequest"
  
  scope :employees , where(:role => "employee")
  scope :active , where(:active => true)
  
  (ALL_ROLES - ["user"]).each do |role|
    class_eval <<-METHODS, __FILE__, __LINE__ + 1
      def is_#{role}?
        return self.role.include? "#{role}"
      end
    METHODS
  end
  
  def self.create_with_omniauth(auth)
    password = Util.generate_alphanumeric_string
    User.create!(:name => auth["user_info"]["name"] , "#{auth['provider']}_uid".to_sym => auth["uid"] , :email => "u#{Util.generate_alphanumeric_string(3) + Time.now.to_i.to_s}@ts1.com" , :password => password , :password_confirmation => password , :confirmed_at => Time.now , :role => ["user"])
  end
  
  def am_i_public?
    return !self.is_private
  end
  
  def confirmation_required?
    (employee_not_admin) && super
  end
  
  def follow(following_users_id)
    return false unless Util.is_ObjectId(following_users_id)
    return follow_(following_users_id) unless !User.is_profile_private(following_users_id)
    return FollowRequest.add_request(self.id,following_users_id)
  end
  
  def unfollow(following_users_id)
    return false unless Util.is_ObjectId(following_users_id)
    return unfollow_(following_users_id)
  end
  
  def remove_follower(follower_id)
    return false unless Util.is_ObjectId(follower_id)
    return remove_follower_(follower_id)
  end
  
  def accept(follow_request_id)
    return false unless Util.is_ObjectId(follow_request_id)
    return ( FollowRequest.accept(follow_request_id) and add_follower_by_request(follow_request_id) )
  end
  
  def add_follower_by_request(follow_request)
    return false unless Util.is_ObjectId(follow_request_id)
    return add_follower_  FollowRequest.initiator(follow_request)
  end
  
  def decline(follow_request_id)
    return false unless Util.is_ObjectId(follow_request_id)
    return FollowRequest.decline(follow_request_id)
  end
  
  def assigned_service_cases
    return [] unless self.is_employee?
    return ServiceCase.my_service_cases(self.id)
  end
  
  def self.verify_id(id)
    return Util.is_What( User.find(id) , "User")
  end
  
  protected
  
  def employee_not_admin
    @is_employee_not_admin ||= ( self.role.include? "employee" and !self.role.include? "admin" )
  end
  
  def check_role
    self.role.delete_if { |r| r.blank? }
  end
  
  def update_private_profiles
    if self.is_private
      User.add_private_profile self.id
    else
      User.remove_private_profile self.id
    end
  end
  
  def follow_(user_id)
    return Util.is_What self.followers.create!(:following_id => user_id), "Follow"
  end
  
  def unfollow_(user_id)
    return ( self.followers.find_by_following_id(user_id).try(:destroy) || false )
  end
  
  def remove_follower_(user_id)
    return ( self.followings.find_by_follower_id(user_id).try(:destroy) || false )
  end
  
  def add_follower_(user_id)
    return Util.is_What self.followings.create!(:follower_id => user_id), "Follow"
  end
   
end
