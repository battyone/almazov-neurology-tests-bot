require 'active_record'
require 'logger'

class DatabaseConnector
  class << self
    def establish_connection
      ActiveRecord::Base.logger = Logger.new(active_record_logger_path)

      configuration = if ENV['DATABASE_URL']
                        ENV['DATABASE_URL']
                      else
                        YAML::load(IO.read(database_config_path))
                      end

      ActiveRecord::Base.establish_connection(configuration)
    end

    private

    def active_record_logger_path
      'debug.log'
    end

    def database_config_path
      'config/database.yml'
    end
  end
end
