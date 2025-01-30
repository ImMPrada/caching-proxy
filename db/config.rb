require 'active_record'
require 'yaml'
require 'erb'

module Db
  class Config
    class << self
      def establish_connection
        ActiveRecord::Base.establish_connection(configuration)
      end

      private

      def configuration
        YAML.safe_load(
          ERB.new(
            File.read(database_config_path)
          ).result,
          aliases: true
        )[environment]
      end

      def database_config_path
        File.join(root_path, 'config', 'database.yml')
      end

      def root_path
        File.expand_path('..', __dir__)
      end

      def environment
        ENV['RACK_ENV'] || 'development'
      end
    end
  end
end
