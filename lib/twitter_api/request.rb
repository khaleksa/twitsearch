module TwitterApi
  class Request
    include HTTParty

    attr_accessor :url, :response, :parsed_data

    base_uri 'https://api.twitter.com'

    def initialize
      @oauth_token = nil
    end

    def params
      @params ||= {}
    end

    def headers
      @headers ||= @oauth_token.present? ? { 'Authorization' => " Bearer #{@oauth_token}" } : {}
    end

    def perform
      send_request
      self.parsed_data = parsed_response
    end

    def send_request
      result = self.class.get(url, query: params, headers: headers)
      binding.pry
      raise RuntimeError, result.parsed_response if result.code >= 400
      self.response = result.parsed_response
    rescue => error
      logger.error "TwitterApi::Request has got exception - #{error.message}, url - '#{url}', params - #{params}, headers - #{headers}"
    end

    def parsed_response
      response
    end

    private

    def logger
      @logger ||= ::Logger.new("#{Rails.root}/log/twitter_api.log")
    end
  end
end