require 'base64'

module TwitterApi
  class OauthToken < Request
    def initialize(url, key, secret)
      @url = url
      @key = key
      @secret = secret
    end

    def headers
      {
          'Authorization' => "Basic #{credentials}",
          'Content-Type' => 'application/x-www-form-urlencoded;charset=UTF-8'
      }
    end

    def send_request
      result = self.class.post(@url, headers: headers, body: 'grant_type=client_credentials' )
      self.response = result.parsed_response
      raise RuntimeError, result.parsed_response if result.code >= 400
    rescue => error
      logger.error "TwitterApi::OauthToken has got exception - #{error.message}, headers - #{headers}"
      raise error
    end

    def parsed_response
      response['access_token']
    end

    def credentials
      return @bearer_token_credentials if @bearer_token_credentials.present?
      key = CGI.escape(@key)
      secret = CGI.escape(@secret)
      @bearer_token_credentials = Base64.strict_encode64("#{key}:#{secret}")
    end

  end
end
