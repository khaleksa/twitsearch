require 'spec_helper'

describe TwitterApi::Locations do
  subject { described_class.new('/somepath/locations', 'SomeTokenValue') }

  let(:response_data) {[
      {
          'country' => 'Sweden',
          'countryCode' => 'SE',
          'name' => 'Sweden',
          'parentid' => 1,
          'placeType' => {
              'code' => 12,
              'name' => 'Country'
          },
          'url' => 'http://where.yahooapis.com/v1/place/23424954',
          'woeid' => 23424954
      },
      {
          'country' => 'United States',
          'countryCode' => 'US',
          'name' => 'New Haven',
          'parentid' => 23424977,
          'placeType' => {
              'code' => 7,
              'name' => 'Town'
          },
          'url' => 'http://where.yahooapis.com/v1/place/2458410',
          'woeid' => 2458410
      }
  ]}

  describe '#parsed_response' do
    let(:parsed_response_result) { subject.parsed_response }

    before do
      allow_any_instance_of(TwitterApi::Locations).to receive(:response).and_return(response_data)
    end

    it 'should return hash of all countries from available twitter locations' do
      expect(parsed_response_result).to be_a(Hash)
      expect(parsed_response_result.size).to eq(1)
    end

    it 'should return valid data' do
      expect(parsed_response_result).to eq({ 23424954 => 'Sweden' })
    end
  end
end
