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
