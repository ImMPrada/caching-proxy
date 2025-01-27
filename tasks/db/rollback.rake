namespace :db do
  desc 'Roll back the last migration'
  task :rollback do
    CachingProxy::DbConfig.establish_connection
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Base.connection.migration_context.rollback(step)

    puts 'Database rollback completed'
  end
end
