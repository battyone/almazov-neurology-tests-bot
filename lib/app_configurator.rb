require 'logger'
require 'dotenv/load'
require './lib/database_connector'

class AppConfigurator
  def configure
    setup_i18n
    setup_database
  end

  def get_token
    ENV['TOKEN']
  end

  def get_logger
    Logger.new(STDOUT, Logger::DEBUG)
  end

  private

  def setup_i18n
    I18n.load_path = Dir['config/locales.yml']
    I18n.default_locale = :ru
    I18n.backend.load_translations
  end

  def setup_database
    DatabaseConnector.establish_connection
  end
end
