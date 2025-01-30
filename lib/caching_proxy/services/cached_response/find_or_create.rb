module CachingProxy
  module Services
    module CachedResponse
      class FindOrCreate
        attr_reader :request, :headers, :status, :body

        def initialize(origin, request)
          @origin = origin
          @request = request
        end

        def call
          @url = "#{@origin}#{request.path}"
          @cached = cached_response
          return response_from_cache if cached

          response_from_request
        end

        private

        attr_reader :cached, :url, :response

        def cached_response
          http_method = request.request_method
          Models::CachedResponse.find_by(url:, http_method:)
        end

        def response_from_cache
          @headers = JSON.parse(cached.response_headers)
          @headers['X-Cache'] = 'HIT'
          @status = 200
          @body = cached.response_body

          cached
        end

        def response_from_request
          @response = forward_request
          create_cache

          @headers = JSON.parse(cached.response_headers)
          @headers['X-Cache'] = 'MISS'
          @status = response.code.to_i
          @body = cached.response_body

          cached
        end

        def forward_request
          uri = URI(url)
          Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') { |http| http.get(uri.path) }
        end

        def create_cache
          http_method = request.request_method
          headers = response.to_hash.transform_values(&:first)

          @cached = Models::CachedResponse.new(
            url:,
            http_method:,
            request_headers: {}.to_json,
            response_headers: headers.to_json,
            response_body: response.body
          )

          cached.save!
        end
      end
    end
  end
end
