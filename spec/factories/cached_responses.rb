FactoryBot.define do
  factory :cached_response, class: 'CachingProxy::Models::CachedResponse' do
    url { 'http://example.com/test' }
    http_method { 'GET' }
    response_body { '{"test": true}' }
    response_headers { { 'Content-Type' => 'application/json' } }
    expires_at { 1.hour.from_now }
  end
end
