require 'spec_helper'

RSpec.describe CachingProxy::Services::CachedResponse::FindOrCreate do
  let(:origin) { 'https://api.example.com' }
  let(:path) { '/users' }
  let(:request) do
    instance_double(
      Rack::Request,
      path: path,
      request_method: 'GET'
    )
  end
  let(:service) { described_class.new(origin, request) }

  describe '#call' do
    context 'when response is cached' do
      let(:cached_response) do
        create(:cached_response,
               url: "#{origin}#{path}",
               http_method: 'GET',
               request_headers: {}.to_json,
               response_headers: { 'Content-Type' => 'application/json' }.to_json,
               response_body: '{"data": "cached"}')
      end
      let(:result) { service.call }

      before do
        cached_response
        result
      end

      it 'sets X-Cache header to HIT' do
        expect(service.headers['X-Cache']).to eq('HIT')
      end

      it 'returns cached body' do
        expect(service.body).to eq('{"data": "cached"}')
      end

      it 'returns success status' do
        expect(service.status).to eq(200)
      end
    end

    context 'when response is not cached' do
      let(:http_response) do
        instance_double(
          Net::HTTPResponse,
          code: '200',
          body: '{"data": "fresh"}',
          to_hash: { 'Content-Type' => ['application/json'] }
        )
      end
      let(:result) { service.call }

      before do
        allow(Net::HTTP).to receive(:start).and_yield(
          instance_double(Net::HTTP).tap do |http|
            allow(http).to receive(:get).and_return(http_response)
          end
        )

        result
      end

      it 'sets X-Cache header to MISS' do
        expect(service.headers['X-Cache']).to eq('MISS')
      end

      it 'returns fresh body' do
        expect(service.body).to eq('{"data": "fresh"}')
      end

      it 'returns success status' do
        expect(service.status).to eq(200)
      end

      it 'stores correct url in cache' do
        expect(CachingProxy::Models::CachedResponse.last.url).to eq("#{origin}#{path}")
      end

      it 'stores correct http method in cache' do
        expect(CachingProxy::Models::CachedResponse.last.http_method).to eq('GET')
      end

      it 'stores correct response body in cache' do
        expect(CachingProxy::Models::CachedResponse.last.response_body).to eq('{"data": "fresh"}')
      end

      it 'stores correct response headers in cache' do
        expect(JSON.parse(CachingProxy::Models::CachedResponse.last.response_headers))
          .to include('Content-Type' => 'application/json')
      end
    end
  end
end
