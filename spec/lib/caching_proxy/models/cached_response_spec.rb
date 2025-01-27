require 'spec_helper'

RSpec.describe CachingProxy::Models::CachedResponse do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_presence_of(:http_method) }
    it { is_expected.to validate_presence_of(:response_body) }
    it { is_expected.to validate_presence_of(:response_headers) }
  end

  describe '.find_valid_cache' do
    let(:url) { 'http://example.com/test' }
    let(:method) { 'GET' }
    let(:current_time) { Time.local(2024, 3, 18, 12, 0, 0) }

    context 'when there is a valid cache entry' do
      let(:cache) { described_class.find_valid_cache(url, method) }

      before do
        create(:cached_response, url: url, http_method: method)
      end

      it { expect(cache).to be_present }
      it { expect(cache.url).to eq(url) }
      it { expect(cache.http_method).to eq(method) }
    end

    context 'when cache has expired' do
      before do
        Timecop.freeze(current_time) do
          @cached_response = create(:cached_response,
                                    url: url,
                                    http_method: method,
                                    expires_at: current_time)
        end

        Timecop.travel(current_time + 3600) # Avanzar 1 hora
      end

      it 'returns nil' do
        expect(described_class.find_valid_cache(url, method)).to be_nil
      end
    end

    context 'when there is no cache entry' do
      it 'returns nil' do
        expect(described_class.find_valid_cache(url, method)).to be_nil
      end
    end
  end

  describe '#cache_hit?' do
    subject(:cached_response) { build(:cached_response) }

    it 'returns true' do
      expect(cached_response.cache_hit?).to be true
    end
  end
end
