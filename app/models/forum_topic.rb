class ForumTopic
  include MongoMapper::Document
  include Enablable
  include Approvable
  include Lockable
  #include Permalink

  key :title,            String,    :required => true
  key :hits,             Integer,   :default => 0
  key :sticky,           Integer,   :default => 0
  key :posts_count,      Integer,   :default => 0
  #key :locked,           Boolean,   :default => false
  key :last_post_id,     ObjectId
  key :last_updated_at,  DateTime
  key :last_user_id,     ObjectId
  key :forum_id,         ObjectId,  :required => true
  key :user_id,          ObjectId,  :required => true

  timestamps!

  validate :name_duplicity_within_forum

  #has_permalink_on :title , :parent => :forum

  belongs_to :forum
  belongs_to :user
  #many :forum_posts
  #many :interactions

  #before_create

  def post_added(post)
    (post and Util.is_What(post,"ForumPost")) ? add_new_post(post) : false
  end
  
  def interactions
    Interaction.all(:context => "ForumTopic", :context_id => id)
  end

  protected

  def add_new_post(post)
    return false unless status == "active"
    self.posts_count  = self.posts_count + 1
    self.last_post_id = post.id
    return true
  end

  private

  def name_duplicity_within_forum
    name_ = self.title
    topics_ = nil
    topics_ = ForumTopic.where(:title => /#{name_}/i,:forum_id => self.forum.id).all if ( name_ and !name_.empty? )
    if topics_ and !topics_.empty?
      errors.add_to_base("Forum Topic with a same name already exists.")
    end
  end

end

