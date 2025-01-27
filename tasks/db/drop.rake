namespace :db do
  desc 'Drop the database'
  task :drop do
    config = CachingProxy::DbConfig.send(:configuration)
    ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres'))
    ActiveRecord::Base.connection.drop_database(config['database'])

    puts "Database '#{config['database']}' dropped"
  end
end
