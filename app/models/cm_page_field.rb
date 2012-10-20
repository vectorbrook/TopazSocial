class CmPageField
  include MongoMapper::EmbeddedDocument
  
  belongs_to :cm_page
  
  key :name, String, :required => true
  key :value,String, :required => true
  key :created_at , DateTime
  
end
