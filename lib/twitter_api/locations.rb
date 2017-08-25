module TwitterApi
  class Locations < Request

    def initialize(url, token)
      @url = url
      @oauth_token = token
    end

    def params
      {}
    end

    def parsed_response
      countries = {}

      response.each do |location|
        next if location['country'].blank? ||
                location['woeid'].blank? ||
                location['placeType'].blank? ||
                location['placeType']['name'] != 'Country'
        countries[location['woeid']] = location['country']
      end

      countries
    end
  end
end