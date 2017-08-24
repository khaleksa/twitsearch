require 'spec_helper'

describe TwitterProvider do
  subject { described_class }

  describe '.search' do
    let(:search_text) { '@rails' }

    it 'should return array of 100 tweets for searched text' do
      VCR.use_cassette('twitter/search') do
        search_result = subject.search(search_text)
        expect(search_result).to be_a(Array)
        expect(search_result.size).to eq(100)
      end
    end

  end

  describe '.trends' do
    it 'should return top 10 hashtags' do
      VCR.use_cassette('twitter/trends') do
        trends = subject.trends
        expect(trends).to be_a(Array)
        expect(trends.size).to eq(10)
      end
    end
  end
end
