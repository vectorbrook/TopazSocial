class KmPageCategory < Category

  field :parent_category_id, :type => BSON::ObjectId
  field :level, :type => Integer
  field :pages, :type => Array
  
  embeds_many :km_pages

  cattr_reader :per_page
  #@@per_page = 25
  
  before_save :adjust_level
  after_save :adjust_children_level
  
  def parent_category
    KmPageCategory.where(:id => self.parent_category_id).first || self
  end
  
  def has_parent_category?
    self.parent_category_id != nil
  end
  
  def has_child_category?
    !child_category.empty?
  end
  
  def child_category
    KmPageCategory.where(:parent_category_id => self.id).all
  end
  
  def ancestry
    if has_parent_category?
      [[parent_category.ancestry].flatten << [self.name]].flatten
    else
      [self.name]
    end
  end
  
  protected
  
  def adjust_level
    if has_parent_category?
      self.level = parent_category.level + 1
    else
      self.level = 0  
    end    
  end
  
  def adjust_children_level
    if has_child_category?
      child_category.each do |cat|
        cat.level = self.level + 1
        cat.save        
      end
    end
  end
  
end

