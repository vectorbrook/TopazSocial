class Forum
  include Mongoid::Document
  include Noteable
  include Enablable
  include Approvable
  include Permalink

  field :name, :type => String
  field :description, :type => String
  field :topics_count, :type => Integer,   :default => 0
  field :posts_count, :type => Integer,   :default => 0
  field :position, :type => Integer,   :default => 0
  field :description_html, :type => String
  field :state, :type => String,    :default => "public"
  field :forum_category_id, :type => Moped::BSON::ObjectId

  validate :name_duplicity_within_category

  has_permalink_on :name

  belongs_to :forum_category
  embeds_many :forum_topics

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

