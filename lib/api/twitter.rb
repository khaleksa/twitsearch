require 'base64'

module Api
  class Twitter
    include HTTParty

    DEFAULT_WOEID = 1
    TWITTER_HOST = 'https://twitter.com'
    SEARCH_RESULT_LIMIT = 100

    base_uri 'https://api.twitter.com'

    def initialize
      @config = ::Rails.configuration.twitter
      self.class.headers 'Authorization' => " Bearer #{get_token}"
    end

    def search(search_text)
      params = {
          q: CGI.escape(search_text),
          count: SEARCH_RESULT_LIMIT
      }
      result = self.class.get(@config.api[:search_path], query: params)
      data = JSON.parse(result.body)

      tweets = []
      data['statuses'].each do |tt|
        user_info = tt['user']
        tweet_data = HashWithIndifferentAccess.new({
            text: tt['text'],
            created_at: tt['created_at'],
            user: {
              name: user_info['name'],
              avatar: user_info['profile_image_url'],
              url: "#{TWITTER_HOST}/#{user_info['screen_name']}",
              favorite_count: user_info['favorite_count'].to_i,
              retweet_count: user_info['retweet_count'].to_i
            }
        })
        tweets<<tweet_data
      end
      tweets
    end

    def trends(location_id = DEFAULT_WOEID)
      params = { id: location_id }
      result = self.class.get(@config.api[:trends_path], query: params)
      data = JSON.parse(result.body)

      hashtags = []
      data.first['trends'].each do |trend|
        next if trend['name'].blank? || !is_hashtag?(trend['name']) || trend['tweet_volume'].blank?
        trend_info = HashWithIndifferentAccess.new({
          name: trend['name'],
          url: trend['url'],
          volume: trend['tweet_volume']
        })
        hashtags<<trend_info
      end
      hashtags.sort{ |a, b| b[:volume]<=>a[:volume] }.take(10)
    end

    private

    def get_token
      return @token if @token

      headers = {
          'Authorization' => "Basic #{credentials}",
          'Content-Type' => 'application/x-www-form-urlencoded;charset=UTF-8'
      }
      result = self.class.post(@config.api[:token_path], headers: headers, body: 'grant_type=client_credentials' )
      data = JSON.parse(result.body)
      @token = data['access_token']
    end

    def credentials
      return @bearer_token_credentials if @bearer_token_credentials.present?
      key = CGI.escape(@config.api[:key])
      secret = CGI.escape(@config.api[:secret])
      @bearer_token_credentials = Base64.strict_encode64("#{key}:#{secret}")
    end

    def is_hashtag?(str)
      str.match('^#\w+$').present?
    end
  end
end
