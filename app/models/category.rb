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


class Category
  include MongoMapper::Document
  include AccessControl
  include Enablable

  key :name,           String,   :required => true
  key :description,    String
  key :subcategories,  Array,    :default => ["Generic"]
  timestamps!

  validates_uniqueness_of :name, :case_sensitive => false

  cattr_reader :per_page
  @@per_page = 3

  attr_accessor :new_subcats, :rem_subcats

  scope :active,  where(:enabled => true)

  def to_s
    self.name
  end

  def subcategory_present(subcat=nil)
    return false if subcat == nil
    subcat = Util.subcategorize_string subcat
    return self.subcategories.include? subcat
  end

  def add_subcategory(subcat,user)
    return false unless subcat and Util.is_What(user,"User")
    subcat = Util.subcategorize_string subcat
    if !subcategory_present(subcat)
      return  change_subcategory("add",subcat,user)
    end
    return false
  end

  def remove_subcategory(subcat,user)
    return false unless subcat and Util.is_What(user,"User")
    subcat = Util.subcategorize_string subcat
    if subcategory_present(subcat)
      return  change_subcategory("remove",subcat,user)
    end
    return false
  end

  def extract_addsubcategory(subcat_hash,user)
    return false unless Util.is_What(subcat_hash,"Hash") and !subcat_hash.blank? and Util.is_What(user,"User")
    ret_flag = false
    subcat_hash.values.each do |val|
      ret_flag = add_subcategory(val,user) if !val.blank? and val.is_a? String || ret_flag
    end
    return ret_flag
  end

  def extract_remsubcategory(subcat_hash,user)
    return false unless Util.is_What(subcat_hash,"Hash") and !subcat_hash.blank? and Util.is_What(user,"User")
    ret_flag = false
    subcat_hash.values.each do |val|
      ret_flag = remove_subcategory(val,user) if !val.blank? and val.is_a? String || ret_flag
    end
    return ret_flag
  end

  protected

  def change_subcategory(type,subcat,user)
    return false unless type and subcat and user and self.class.is_permitted(user.role,"modify")
    if type == "add"
      return ( self.subcategories.push subcat ).is_a? Array
    elsif type == "remove"
      return ( self.subcategories.delete subcat ).is_a? String
    else
       return false
    end
  end

end

