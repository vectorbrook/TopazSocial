# TS Admin

admin = User.create(:name => "admin",:email => "admin@ts1.com" , :password => "welcome" , :password_confirmation => "welcome" , :role => ["user","admin","employee"])


# TS Moderator

moderator = User.create(:name => "moderator",:email => "moderator@ts1.com" , :password => "welcome" , :password_confirmation => "welcome" , :role => ["user","moderator","employee"])
moderator.confirm!

# TS Approver

approver = User.create(:name => "approver",:email => "approver@ts1.com" , :password => "welcome" , :password_confirmation => "welcome" , :role => ["user","approver","employee"])
approver.confirm!

# TS Customer

customer = User.create(:name => "customer",:email => "customer@ts1.com" , :password => "welcome" , :password_confirmation => "welcome" , :role => ["user","customer","employee"])
customer.confirm!

# TS Prospect

prospect = User.create(:name => "prospect",:email => "prospect@ts1.com" , :password => "welcome" , :password_confirmation => "welcome" , :role => ["user","prospect","employee"])
prospect.confirm!

# TS Sales Engineer

sales_engineer = User.create(:name => "sales_engineer",:email => "sales_engineer@ts1.com" , :password => "welcome" , :password_confirmation => "welcome" , :role => ["user","sales_engineer","employee"])
sales_engineer.confirm!

# TS Sales Manager

sales_manager = User.create(:name => "sales_manager",:email => "sales_manager@ts1.com" , :password => "welcome" , :password_confirmation => "welcome" , :role => ["user","sales_engineer","sales_manager","employee"])
sales_manager.confirm!

# TS Support Agent

support_agent = User.create(:name => "support_agent",:email => "support_agent@ts1.com" , :password => "welcome" , :password_confirmation => "welcome" , :role => ["user","support_agent","employee"])
support_agent.confirm!

# TS Support Manager

support_manager = User.create(:name => "support_manager",:email => "support_manager@ts1.com" , :password => "welcome" , :password_confirmation => "welcome" , :role => ["user","support_manager","support_manager","employee"])
support_manager.confirm!

# TS Community Manager

community_manager = User.create(:name => "community_manager",:email => "community_manager@ts1.com" , :password => "welcome" , :password_confirmation => "welcome" , :role => ["user","community_manager","employee"])
community_manager.confirm!

# TS Social Media Manager

social_media_manager = User.create(:name => "social_media_manager",:email => "social_media_manager@ts1.com" , :password => "welcome" , :password_confirmation => "welcome" , :role => ["user","social_media_manager","employee"])
social_media_manager.confirm!
