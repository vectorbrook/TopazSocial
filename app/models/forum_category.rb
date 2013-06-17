class ForumCategory < Category

  has_many :forums

  cattr_reader :per_page
  #@@per_page = 3
  
end

