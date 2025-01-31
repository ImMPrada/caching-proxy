require 'active_record'
require_relative '../../db/migrate/20240318000000_create_cached_responses'

CreateCachedResponses.new.up

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ENV['RACK_ENV'] = 'test'
Db::Config.establish_connection
