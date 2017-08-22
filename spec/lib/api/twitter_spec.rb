require 'spec_helper'
require 'api/twitter'

describe Api::Twitter do
  subject { described_class.new }

  let(:config) { Rails.configuration.twitter }
  let(:token) { 'SomeTokenValue' }

  def get_stubbed_request
    allow_any_instance_of(Api::Twitter).to receive(:get_token).and_return(token)

    fixture = File.read(File.expand_path("fixtures/twitter_response.json", File.dirname(__FILE__)))
    headers = { 'Authorization' => "Bearer #{token}" }
    params = { q: CGI.escape(search_text) }
    stub_request(:get, config.api[:search_url])
        .with(query: params, headers: headers)
        .to_return(body: fixture, status: 200, headers: {})
  end

  describe '#search' do
    let(:search_text) { '@rails' }
    let!(:stubbed_request) { get_stubbed_request }

    it 'should return array of tweets for searched text' do
      expect(subject.search(search_text).size).to eq(15)
    end

  end
end
