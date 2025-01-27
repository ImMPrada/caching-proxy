module CachingProxy
  module Models
    class CachedResponse < ActiveRecord::Base
      validates :url, presence: true
      validates :http_method, presence: true
      validates :response_body, presence: true
      validates :response_headers, presence: true

      def self.find_valid_cache(url, method)
        where(url: url, http_method: method.to_s.upcase)
          .where('expires_at IS NULL OR expires_at > ?', Time.current)
          .order(created_at: :desc)
          .first
      end

      def cache_hit?
        true
      end
    end
  end
end
