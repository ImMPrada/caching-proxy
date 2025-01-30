require 'byebug'
require_relative 'db/config'
require_relative 'lib/caching_proxy'

Db::Config.establish_connection
run CachingProxy::Controller.new
