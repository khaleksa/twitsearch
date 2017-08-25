module TwitterApi
  class Trends < Request
    DEFAULT_WOEID = 1

    def initialize(url, token, location_id = DEFAULT_WOEID)
      @url = url
      @oauth_token = token
      @location_id = location_id
    end

    def params
      { id: @location_id }
    end

    def parsed_response
      hashtags = []
      return hashtags unless response.try(:first).try(:[], 'trends')

      response.first['trends'].each do |trend|
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

    def is_hashtag?(str)
      str.match('^#\w+$').present?
    end
  end
end