MongoMapper.database = "ts_#{Rails.env}"
logger = Logger.new('test.log')
MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017, :logger => logger)
MongoMapper.logger

