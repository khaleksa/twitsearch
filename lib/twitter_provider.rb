class TwitterProvider
  CACHE_PERIOD_IN_MINUTE = 5
  LOCATION_CACHE_PERIOD_IN_HOUR = 24

  class << self
    def search(search_text)
      Rails.cache.fetch("twitter_api/search/#{Digest::MD5.hexdigest(search_text)}", expires_in: CACHE_PERIOD_IN_MINUTE.minute) do
        TwitterApi::Search.new(config[:search_path], oauth_token, search_text).perform
      end
    rescue => exception
      Rails.logger.error "#{Time.zone.now}: TwitterProvider.search failed to search for '#{search_text}', error: #{exception.message}"
      nil
    end

    def trends(woeid = TwitterApi::Trends::DEFAULT_WOEID)
      Rails.cache.fetch("/#{woeid}", expires_in: CACHE_PERIOD_IN_MINUTE.minute) do
        TwitterApi::Trends.new(config[:trends_path], oauth_token, woeid).perform
      end
    rescue => exception
      Rails.logger.error "#{Time.zone.now}: TwitterProvider.trends failed, error: #{exception.message}"
      nil
    end

    def locations
      @locations ||= Rails.cache.fetch('twitter_api/locations', expires_in: LOCATION_CACHE_PERIOD_IN_HOUR.hours) do
        TwitterApi::Locations.new(config[:locations_path], oauth_token).perform
      end
    rescue => exception
      Rails.logger.error "#{Time.zone.now}: TwitterProvider.locations failed, error: #{exception.message}"
      {}
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
