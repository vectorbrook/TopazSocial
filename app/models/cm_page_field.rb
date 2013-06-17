class CmPageField
  include Mongoid::Document
  
  embedded_in :cm_page
  
  field :name, :type => String
  field :value, :type => String
  field :created_at , :type => DateTime
  
end
