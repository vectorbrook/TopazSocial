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


class Util

  CHARS = ("a".."z").to_a + ("1".."9").to_a

  def self.subcategorize_string(str=nil)
    return "" if str == nil
    return str.downcase.squeeze(' ').strip.titleize
  end

  def self.generate_alphanumeric_string(len=nil)
    return Array.new((len.try(:to_i) ? len.to_i : 8), '').collect{CHARS[rand(CHARS.size)]}.join
  end

  def self.is_ObjectId(object_id)
    return ( object_id.try(:is_a?,BSON::ObjectId) || false )
  end

  def self.is_What(obj,klass)
    return ( obj.try(:is_a?,klass.constantize) || false )
  end

  def self.add_default_roles(arr)
    return ( ( arr || [] ) + DEFAULT_ROLES ).uniq
  end

  def self.arrayify(arr)
    return ( arr if Util.is_What(arr,"Array") )  || ( arr.split if Util.is_What(arr,"String") ) || []
  end

  def self.concatify_attribute(attr_val)
    return ( attr_val and !attr_val.empty?  ? ", " + attr_val.to_s : nil )
  end

  def self.resourcify(controller_)
    ret = controller_.classify
    return ( (RESOURCES.include? ret) ? ret : nil )
  end

  def self.map_action(action_)
    case action_
      when "new","create"
        return "create"
      when "edit","update"
        return "modify"
      when "index"
        return "read"
      when "delete","enable","disable","approve","disapprove"
        return action_
      else
        return nil
    end
  end

end

