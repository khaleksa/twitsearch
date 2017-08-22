require 'base64'

module Api
  class Twitter
    include HTTParty

    def initialize
      @config = ::Rails.configuration.twitter
    end

    def search(search_text)
      headers = { 'Authorization' => " Bearer #{get_token}" }
      params = { q: CGI.escape(search_text) }
      result = self.class.get(@config.api[:search_url], headers: headers, query: params )
      data = JSON.parse(result.body)
      data['statuses']
    end

    private

    def get_token
      return @token if @token

      headers = {
          'Authorization' => "Basic #{credentials}",
          'Content-Type' => 'application/x-www-form-urlencoded;charset=UTF-8'
      }
      result = self.class.post(@config.api[:token_url], headers: headers, body: 'grant_type=client_credentials' )
      data = JSON.parse(result.body)
      @token = data['access_token']
    end

    def credentials
      return @bearer_token_credentials if @bearer_token_credentials.present?
      key = CGI.escape(@config.api[:key])
      secret = CGI.escape(@config.api[:secret])
      @bearer_token_credentials = Base64.strict_encode64("#{key}:#{secret}")
    end
  end
end
