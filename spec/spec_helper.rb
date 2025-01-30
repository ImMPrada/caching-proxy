require 'rspec'
require 'database_cleaner'
require 'timecop'
require_relative '../db/config'

# Load the application code
require_relative '../lib/caching_proxy'

# Load support files
Dir[File.join(__dir__, 'support', '**', '*.rb')].each { |f| require f }

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
end
