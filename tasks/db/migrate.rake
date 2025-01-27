# frozen_string_literal: true

namespace :db do
  desc 'Run database migrations'
  task :migrate do
    CachingProxy::DbConfig.establish_connection
    ActiveRecord::Tasks::DatabaseTasks.migrate
  end
end
