class TwitterProvider
  class << self
    def search(search_text)
      TwitterApi::Search.new(config[:search_path], oauth_token, search_text).perform
    end

    def trends
      TwitterApi::Trends.new(config[:trends_path], oauth_token).perform
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
