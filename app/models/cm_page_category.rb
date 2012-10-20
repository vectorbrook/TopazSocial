class CmPageCategory < Category

  key :parent_category_id, ObjectId
  key :level, Integer, :default => 0
  key :pages, Array
  
  many :cm_pages

  cattr_reader :per_page
  #@@per_page = 25
  
  before_save :adjust_level
  after_save :adjust_children_level
  
  def parent_category
    CmPageCategory.where(:id => self.parent_category_id).first || self
  end
  
  def has_parent_category?
    self.parent_category_id != nil
  end
  
  def has_child_category?
    !child_category.empty?
  end
  
  def child_category
    CmPageCategory.where(:parent_category_id => self.id).all
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

