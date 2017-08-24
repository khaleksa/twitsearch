require 'spec_helper'

describe TwitterProvider do
  subject { described_class }

  let(:config) { Rails.configuration.twitter }
  let(:token) { 'SomeTokenValue' }

  def get_stubbed_request(url, fixture_name)
    fixture = File.read(File.expand_path("twitter_api/fixtures/#{fixture_name}.json", File.dirname(__FILE__)))
    headers = { 'Authorization' => "Bearer #{token}" }
    stub_request(:get, url)
        .with(query: params, headers: headers)
        .to_return(body: fixture, status: 200, headers: {})
  end

  before do
    allow_any_instance_of(TwitterApi::OauthToken).to receive(:perform).and_return(token)
    get_stubbed_request(request_url, result_fixture)
  end

  describe '.search' do
    let(:request_url) { "https://api.twitter.com#{config.api[:search_path]}" }
    let(:result_fixture) { 'twitter_search' }
    let(:params) {{ q: CGI.escape(search_text), count: 100 }}
    let(:search_text) { '@rails' }

    it 'should return array of tweets for searched text' do
      expect(subject.search(search_text).size).to eq(15)
    end
  end

  describe '.trends' do
    let(:request_url) { "https://api.twitter.com#{config.api[:trends_path]}" }
    let(:result_fixture) { 'twitter_trends' }
    let(:params) {{ id: 1 }}

    it 'should return top 10 hashtags' do
      expect(subject.trends.size).to eq(10)
    end
  end
end
