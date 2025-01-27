namespace :db do
  desc 'Create the database'
  task :create do
    config = CachingProxy::DbConfig.send(:configuration)
    ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres'))
    ActiveRecord::Base.connection.create_database(config['database'])

    puts "Database '#{config['database']}' created"
  rescue ActiveRecord::DatabaseAlreadyExists
    puts "Database '#{config['database']}' already exists"
  end
end
