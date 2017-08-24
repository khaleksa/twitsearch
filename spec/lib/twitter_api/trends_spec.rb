require 'spec_helper'

describe TwitterApi::Trends do
  subject { described_class.new('/somepath/search', 'SomeTokenValue', 1) }

  let(:fixture) do
    data = File.read(File.expand_path("fixtures/twitter_trends.json", File.dirname(__FILE__)))
    JSON.parse(data)
  end
  let(:parsed_response_result) { subject.parsed_response }

  describe '#parsed_response' do
    let(:trend) { parsed_response_result.first }

    before do
      allow_any_instance_of(TwitterApi::Trends).to receive(:response).and_return(fixture)
    end

    it 'should return top 10 hashtags' do
      expect(parsed_response_result).to be_a(Array)
      expect(parsed_response_result.size).to eq(10)
    end

    it 'should return valid data' do
      expect(trend).to eq(HashWithIndifferentAccess.new({
          name: '#TripleTalaq',
          url: 'http://twitter.com/search?q=%23TripleTalaq',
          volume: 258209,
      }))
    end
  end
end
