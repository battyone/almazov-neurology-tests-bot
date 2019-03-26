require 'rubygems'
require 'bundler/setup'

require 'pg'
require 'active_record'
require 'yaml'

connection_details = if ENV['DATABASE_URL']
                       ENV['DATABASE_URL']
                     else
                       YAML::load(File.open('config/database.yml'))
                     end

namespace :db do

  desc 'Migrate the database'
  task :migrate do
    ActiveRecord::Base.establish_connection(connection_details)
    ActiveRecord::Migrator.migrate('db/migrate/')
  end

  desc 'Create the database'
  task :create do
    admin_connection = connection_details.merge({'database'=> 'postgres',
                                                'schema_search_path'=> 'public'})
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.create_database(connection_details.fetch('database'))
  end

  desc 'Drop the database'
  task :drop do
    admin_connection = connection_details.merge({'database'=> 'postgres',
                                                'schema_search_path'=> 'public'})
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.drop_database(connection_details.fetch('database'))
  end
end
