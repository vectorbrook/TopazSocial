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


class Contact
  include MongoMapper::Document
  include Noteable
  include Enablable
  include AccessControl
 
  key :first_name, String , :required => true
  key :last_name, String , :required => true
  key :phone_number1, String , :required => true
  key :phone_number2, String 
  key :phone_number3, String 
  key :fax_number, String 
  key :email_addr, String , :required => true
  key :sell_to, Boolean 
  key :ship_to, Boolean 
  key :bill_to, Boolean
  key :site_id , ObjectId, :required => true
  #key :notes,  Array, :typecast => 'String'
  #key :enabled, Boolean, :required => true 

  timestamps!

  belongs_to :site
  
  privilegify "admin",["all"]
  
  def full_name
    self.first_name + " " + self.last_name
  end
  
  def full_details
    (%w[phone_number1 phone_number2 phone_number3 fax_number email_addr].collect { |a| Util.concatify_attribute(self.send(a.to_sym)) }.join)[2...2000]
  end
    
end
