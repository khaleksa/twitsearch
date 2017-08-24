module TwitterApi
  class Search < Request
    TWITTER_HOST = 'https://twitter.com'
    SEARCH_RESULT_LIMIT = 100

    def initialize(url, token, search_text)
      @url = url
      @oauth_token = token
      @search_text = search_text
    end

    def params
      {
          q: CGI.escape(@search_text),
          count: SEARCH_RESULT_LIMIT
      }
    end

    def parsed_response
      tweets = []
      response['statuses'].each do |tt|
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
  end
end