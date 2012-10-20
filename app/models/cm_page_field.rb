class CmPageField
  include MongoMapper::EmbeddedDocument
  
  embedded_in :cm_page
  
  key :name, String, :required => true
  key :value,String, :required => true
  key :created_at , DateTime
  
end
