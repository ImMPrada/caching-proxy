require 'active_record'
require 'database_cleaner/active_record'
require 'timecop'
require 'factory_bot'
require 'shoulda-matchers'
require_relative '../db/db_config'
require_relative '../lib/caching_proxy/models/cached_response'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around do |example|
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
CachingProxy::DbConfig.establish_connection
