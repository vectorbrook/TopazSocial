class CmPage
  include MongoMapper::Document
  include Enablable
  include Approvable
  include Lockable
  #include Permalink

  key :title,            String,    :required => true, :unique => true
  key :hits,             Integer,   :default => 0
  #key :locked,          Boolean,   :default => false
  key :content,          String,    :required => true
  key :last_updated_id,  ObjectId
  key :last_updated_at,  DateTime
  key :last_user_id,     ObjectId
  key :cm_page_category_id, ObjectId,  :required => true
  key :user_id,          ObjectId,  :required => true
  key :slug,             String,   :unique => true

  timestamps!

  #has_permalink_on :title , :parent => :forum

  belongs_to :cm_page_category
  belongs_to :user
  many :cm_page_fields
  
  before_save :create_slug
  
  def interactions
    Interaction.all(:context => "CmPage", :context_id => id)
  end
  
  def to_param
    self.slug
  end
  
  protected
  
  def create_slug
    self.slug = self.title.downcase.gsub(/[^a-z1-9]+/, '-').chomp('-')
  end

  private
  
end

