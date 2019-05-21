require 'sequel'

module Freska
  class SqlConnectionFactory
    class_attribute :connection_pool

    def self.create(settings, logger)
      db_config = settings.all.database.merge(logger: logger)
      self.connection_pool ||= Sequel.connect(db_config)
      self.connection_pool.disconnect

      self.connection_pool
    end
  end
end
