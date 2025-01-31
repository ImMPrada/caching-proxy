require 'active_record'
require 'rack'
require 'net/http'
require 'json'
require 'uri'

# Require all Ruby files in lib/caching_proxy directory recursively
Dir[File.join(__dir__, 'caching_proxy', '**', '*.rb')].each { |file| require_relative file }

module CachingProxy
end
