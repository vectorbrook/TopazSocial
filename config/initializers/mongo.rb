MongoMapper.database = "tsmhq1"
logger = Logger.new('test.log')

MongoMapper.connection = Mongo::Connection.new('staff.mongohq.com', 10083, { :logger => Rails.logger })
MongoMapper.database.authenticate('ts7952m1', 'v5$M%8)+')

MongoMapper.logger


if defined?(PhusionPassenger)
   PhusionPassenger.on_event(:starting_worker_process) do |forked|
     MongoMapper.connection.connect_to_master if forked
   end
end
