# TS Admin

admin = User.create(:name => "admin",:email => "admin@ts1.com" , :password => "welcome500" , :password_confirmation => "welcome500" , :category => EMPLOYEE_CATEGORY, :role => ["admin","employee"])

# TS Customer

customer = User.create(:name => "customer",:email => "customer@ts1.com" , :password => "welcome500" , :password_confirmation => "welcome500" , :category => CUSTOMER_CATEGORY, :role => [CUSTOMER_ROLES_DEFAULT])
customer.confirm!

# TS Prospect

prospect = User.create(:name => "prospect",:email => "prospect@ts1.com" , :password => "welcome500" , :password_confirmation => "welcome500" , :category => PROSPECT_CATEGORY, :role => [PROSPECT_ROLES_DEFAULT])
prospect.confirm!

# TS Sales Engineer

sales_engineer = User.create(:name => "sales_engineer",:email => "sales_engineer@ts1.com" , :password => "welcome500" , :password_confirmation => "welcome500" , :category => EMPLOYEE_CATEGORY, :role => ["sales_engineer","employee"])
sales_engineer.confirm!

# TS Sales Manager

sales_manager = User.create(:name => "sales_manager",:email => "sales_manager@ts1.com" , :password => "welcome500" , :password_confirmation => "welcome500" , :category => EMPLOYEE_CATEGORY, :role => ["sales_engineer","sales_manager","employee"])
sales_manager.confirm!

# TS Service Agent

service_agent = User.create(:name => "service_agent",:email => "service_agent@ts1.com" , :password => "welcome500" , :password_confirmation => "welcome500" , :category => EMPLOYEE_CATEGORY, :role => ["service_agent","employee"])
service_agent.confirm!

# TS Service Manager

service_manager = User.create(:name => "service_manager",:email => "service_manager@ts1.com" , :password => "welcome500" , :password_confirmation => "welcome500" , :category => EMPLOYEE_CATEGORY, :role => ["service_agent","service_manager","employee"])
service_manager.confirm!

# TS Community Manager

community_manager = User.create(:name => "community_manager",:email => "community_manager@ts1.com" , :password => "welcome500" , :password_confirmation => "welcome500" , :category => EMPLOYEE_CATEGORY, :role => ["community_manager","employee"])
community_manager.confirm!

# TS Social Media Manager

social_media_manager = User.create(:name => "social_media_manager",:email => "social_media_manager@ts1.com" , :password => "welcome500" , :password_confirmation => "welcome500" , :category => EMPLOYEE_CATEGORY, :role => ["social_media_manager","employee"])
social_media_manager.confirm!
