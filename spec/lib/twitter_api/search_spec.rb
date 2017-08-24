require 'spec_helper'

describe TwitterApi::Search do
  subject { described_class.new('/somepath/search', 'SomeTokenValue', 'Ruby on rails') }

  let(:response_data) {{
    'statuses' => [
      {
        'text' => 'Ruby on rails is the best framework',
        'created_at' => 'Sun Aug 20 19:20:23 +0000 2017',
        'user' => {
          'name' => 'Mark Locklear',
          'profile_image_url' => 'http://pbs.twimg.com/profile_images/860208849294426113/some_avatar.jpg',
          'screen_name' => 'markloklear',
          'favorite_count' => 452,
          'retweet_count' => 64
        }
      },
      {
          'text' => 'I love ruby on rails',
          'created_at' => 'Sun Aug 21 19:20:23 +0000 2017',
          'user' => {
              'name' => 'John Smith',
              'profile_image_url' => 'http://pbs.twimg.com/profile_images/860208849294426113/other_avatar.jpg',
              'screen_name' => 'johnsmith',
              'favorite_count' => 15,
              'retweet_count' => 0
          }
      }
    ]
  }}

  describe '#parsed_response' do
    let(:parsed_response_result) { subject.parsed_response }
    let(:tweet) { parsed_response_result.first }

    before do
      allow_any_instance_of(TwitterApi::Request).to receive(:response).and_return(response_data)
    end

    it 'should return array of all tweets from request response' do
      expect(parsed_response_result).to be_a(Array)
      expect(parsed_response_result.size).to eq(2)
    end

    it 'should return valid data' do
      expect(tweet).to eq(HashWithIndifferentAccess.new({
          text: 'Ruby on rails is the best framework',
          created_at: 'Sun Aug 20 19:20:23 +0000 2017',
          user: {
              name: 'Mark Locklear',
              avatar: 'http://pbs.twimg.com/profile_images/860208849294426113/some_avatar.jpg',
              url: "#{TwitterApi::Search::TWITTER_HOST}/markloklear",
              favorite_count: 452,
              retweet_count: 64
          }
      }))
    end
  end
end
