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


class ServiceCase
  include MongoMapper::Document
  include AccessControl
  include Notable
  include Enablable
  
  key :name , String, :required => true
  key :description , String, :required => true
  key :type , Integer
  key :priority , Integer, :required => true , :in => SERVICECASE_PRIORITIES #%w[Critical Feature Important High Normal Low]    # or case_severity
  key :impact , String
  key :status , String, :required => true , :in => SERVICECASE_STATUSES
  key :solution , String
  key :created_by, ObjectId  , :required => true
  key :assigned_to, ObjectId
  key :account_id, ObjectId , :required => true
  key :contact_id, ObjectId
  key :visible_to, Array, :typecast => 'ObjectId'
  key :tags, Array, :typecast => 'String'
  #key :notes,  Array, :typecast => 'String'
  #key :enabled, Boolean, :required => true

  timestamps!

  belongs_to :account
  many :service_case_logs
  many :service_case_interactions
  
  privilegify "admin",["all"]
  
  before_save :make_log_entry
  
  cattr_reader :per_page
  @@per_page = 3
  
  def self.my_service_cases(user_id)
    return [] unless Util.is_ObjectId(user_id)
    return ServiceCase.find_all_by_assigned_to(user_id)
  end
  
  def assign_to(user_id)
    return false unless Util.is_What(user_id,"String")
    return assign_to_(user_id)
  end
  
  protected
  
  def make_log_entry
    self.service_case_logs.build(:log_text => self.changes.inspect , :created_at => Time.now)
  end
  
  def assign_to_(user_id)
    if User.verify_id(user_id)
      self.assigned_to = (User.find user_id).id
      self.status = "Open"
      return true
    end
    return false
  end
  
end
