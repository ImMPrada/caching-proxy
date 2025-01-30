require 'rack/test'
require 'rspec'
require 'active_record'
require 'database_cleaner'
require 'timecop'
require 'factory_bot'
require 'shoulda-matchers'
require_relative '../db/config'

# Load the application code
require_relative '../lib/caching_proxy'

# Configure the test database connection
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

# Load the migration and create the table
require_relative '../db/migrate/20240318000000_create_cached_responses'
CreateCachedResponses.new.up

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.after do
    Timecop.return
  end

  # Configure FactoryBot
  config.include FactoryBot::Syntax::Methods
  config.include Shoulda::Matchers::ActiveModel

  config.before(:suite) do
    FactoryBot.find_definitions
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
  end
end

ENV['RACK_ENV'] = 'test'
Db::Config.establish_connection
