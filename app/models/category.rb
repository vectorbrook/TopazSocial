class Category
  include MongoMapper::Document
  include Enablable

  key :name,           String,   :required => true
  key :description,    String
  key :subcategories,  Array
  timestamps!

  validates_uniqueness_of :name, :case_sensitive => false

  cattr_reader :per_page
  #@@per_page = 3

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

  def add_subcategory(user, subcat=nil)
    return false unless subcat and Util.is_What(user,"User")
    subcat = Util.subcategorize_string subcat
    if !subcategory_present(subcat)
      return  change_subcategory("add",subcat,user)
    end
    return false
  end

  def remove_subcategory(user, subcat=nil)
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

