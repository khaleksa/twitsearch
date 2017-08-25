class TwitterProvider
  CACHE_PERIOD_IN_MINUTE = 5

  class << self
    def search(search_text)
      Rails.cache.fetch("twitter_api/search/#{Digest::MD5.hexdigest(search_text)}", expires_in: CACHE_PERIOD_IN_MINUTE.minute) do
        TwitterApi::Search.new(config[:search_path], oauth_token, search_text).perform
      end
    rescue => exception
      Rails.logger.error "#{Time.zone.now}: TwitterProvider.search failed to search for '#{search_text}', error: #{exception.message}"
      nil
    end

    def trends
      Rails.cache.fetch('twitter_api/trends', expires_in: CACHE_PERIOD_IN_MINUTE.minute) do
        TwitterApi::Trends.new(config[:trends_path], oauth_token).perform
      end
    rescue => exception
      Rails.logger.error "#{Time.zone.now}: TwitterProvider.trends failed, error: #{exception.message}"
      nil
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
