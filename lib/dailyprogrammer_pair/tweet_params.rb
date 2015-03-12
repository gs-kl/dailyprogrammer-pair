module DailyprogrammerPair
  class TweetParams
    attr_reader :tweet

    def initialize tweet
      @tweet = tweet
    end

    def has_shortened_url?
      @tweet.text.match(/http:\/\/t.co\/\S*/)
    end

    def shortened_url
      @tweet.text.match(/http:\/\/t.co\/\S*/)[0]
    end

    def expanded_url
      uri = URI(shortened_url)
      Net::HTTP.new(uri.host, uri.port).get(uri.path).header["location"]
    end
  end
end
