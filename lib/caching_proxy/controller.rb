module CachingProxy
  class Controller
    attr_reader :origin, :request, :response, :headers

    def initialize
      @origin = ENV.fetch('ORIGIN_URL', nil)
    end

    def call(env)
      @request = Rack::Request.new(env)
      service = Services::CachedResponse::FindOrCreate.new(origin, request)
      service.call

      [service.status, service.headers, [service.body]]
    end
  end
end
