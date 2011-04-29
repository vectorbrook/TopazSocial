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


class Site
  include MongoMapper::Document
  include Noteable
  include Enablable
  include AccessControl
 
  key :name, String, :required => true  
  key :description, String
  key :address_line1, String , :required => true  
  key :address_line2, String 
  key :city, String , :required => true  
  key :state, String , :required => true  
  key :country, String , :required => true  , :default => "US"
  key :zipcode, String, :required => true  
  key :account_id , ObjectId
  #key :notes,  Array, :typecast => 'String'
  #key :enabled, Boolean, :required => true 
  
  attr_accessor :temp

  timestamps!

  many :contacts
  belongs_to :account
  
  privilegify "admin" , ["all"]
  
  def full_address
    (%w[address_line1 address_line2 city state country zipcode].collect { |a| Util.concatify_attribute(self.send(a.to_sym)) }.join)[2...2000]
  end
  
  protected
  
  
end
