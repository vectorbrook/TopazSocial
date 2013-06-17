class ForumTopic
  include Mongoid::Document
  include Mongoid::Timestamps
  include Enablable
  include Approvable
  include Lockable
  #include Permalink

  field :title, :type => String
  field :hits, :type => Integer,   :default => 0
  field :sticky, :type => Integer,   :default => 0
  field :posts_count, :type => Integer,   :default => 0
  field :last_post_id, :type => Moped::BSON::ObjectId
  field :last_updated_at, :type => DateTime
  field :last_user_id, :type => Moped::BSON::ObjectId
  field :user_id, :type => Moped::BSON::ObjectId

  validate :name_duplicity_within_forum

  #has_permalink_on :title , :parent => :forum

  embedded_in :forum
  belongs_to :user

  def post_added(post)
    (post and Util.is_What(post,"ForumPost")) ? add_new_post(post) : false
  end

  def interactions
    Interaction.all(:context => "ForumTopic", :context_id => id,:parent_context => "Forum", :parent_context_id => self.forum.id)
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
    forum = self.forum
    topics_ = forum.forum_topics.select {|topic| topic.title =~ /#{name_}/i && topic.id != self.id} if ( name_ and !name_.empty? )
    p topics_
    if topics_ and !topics_.empty?
      errors.add(:title,"Topic with a same name already exists.")
    end
  end

end
