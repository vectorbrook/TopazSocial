class Forum
  include MongoMapper::Document
  include Noteable
  include Enablable
  include Approvable
  include Permalink

  key :name,               String,    :required => true
  key :description,        String
  key :topics_count,       Integer,   :default => 0
  key :posts_count,        Integer,   :default => 0
  key :position,           Integer,   :default => 0
  key :description_html,   String
  key :state,              String,    :default => "public"
  key :forum_category_id,  ObjectId,  :required => true

  validate :name_duplicity_within_category

  has_permalink_on :name

  belongs_to :forum_category
  many :forum_topics

  attr_accessible :name , :description, :forum_category_id

  cattr_reader :per_page
  @@per_page = 3

  scope :active,   where(:enabled => true , :approved => true )
  scope :pending,  where(:enabled => true , :approved => false , :approved_by => nil)
  scope :disabled, where(:enabled => false , :approved => true )

  def topic_added(save_=true)
    self.topics_count = self.topics_count + 1
    save if save_
  end

  def post_added(save_=true)

  end

  def category_active
    return self.forum_category.is_enabled?
  end

  def is_active?
    return ( is_approved? and is_enabled? and category_active )
  end

  def status
    if has_been_approved?
      if is_approved?
        if is_enabled?
          if is_active?
            return "Active"
          else
            return "Disabled: Parent Category Disabled"
          end
        else
          return "Disabled"
        end
      else
        return "Disapproved"
      end
    else
      return "Pending"
    end
  end

  private

  def name_duplicity_within_category
    name_ = self.name
    forums_ = nil
    forums_ = Forum.where(:name => /#{name_}/i,:forum_category_id => self.forum_category_id).all if ( name_ and !name_.empty? )
    if self.new_record? and forums_ and !forums_.empty?
      errors.add(:base, "Forum with a same name already exists.")
    end
  end

end

