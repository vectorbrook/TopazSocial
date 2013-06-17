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
    return ( object_id.try(:is_a?,Moped::BSON::ObjectId) || false )
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

