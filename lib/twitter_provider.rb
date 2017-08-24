class TwitterProvider
  class << self
    def search(search_text)
      Rails.cache.fetch("twitter_api/search/#{Digest::MD5.hexdigest(search_text)}", expires_in: 5.minute) do
        TwitterApi::Search.new(config[:search_path], oauth_token, search_text).perform
      end
    end

    def trends
      Rails.cache.fetch('twitter_api/trends', expires_in: 5.minute) do
        TwitterApi::Trends.new(config[:trends_path], oauth_token).perform
      end
    end

    private

    def config
      @config ||= ::Rails.configuration.twitter.api
    end

    def oauth_token
      @oauth_token ||= TwitterApi::OauthToken.new(config[:token_path], config[:key], config[:secret]).perform
    end
  end
end
