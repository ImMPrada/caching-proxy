require 'active_record'
require 'active_record/tasks/database_tasks'
require 'erb'
require_relative 'db/config'

ActiveRecord::Base.configurations = YAML.safe_load(
  ERB.new(
    File.read(
      File.expand_path('./config/database.yml', __dir__)
    )
  ).result,
  aliases: true
)

ActiveRecord::Tasks::DatabaseTasks.db_dir = 'db'
ActiveRecord::Tasks::DatabaseTasks.migrations_paths = ['db/migrate']

Dir.glob('tasks/**/*.rake').each { |r| load r }
