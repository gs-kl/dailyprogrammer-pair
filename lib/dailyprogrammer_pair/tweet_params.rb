module DailyprogrammerPair
  class NullLanguage
    def to_s
      "no language preference"
    end

    def method_missing(*args, &block)
      self
    end
  end

  class NullShortenedUrl
    def to_s
      nil
    end

    def method_missing(*args, &block)
      self
    end
  end

  class TweetParams
    attr_reader :tweet

    def initialize tweet
      @tweet = tweet
    end

    def shortened_url
      (tweet.text.match(/http:\/\/t.co\/\S*/) || NullShortenedUrl.new)[0].to_s
    end

    def expanded_url
      uri = URI(shortened_url)
      Net::HTTP.new(uri.host, uri.port).get(uri.path).header["location"]
    end

    def language
      (tweet.text.match(/lang:(\w+)/) || NullLanguage.new)[1].to_s
    end
  end
end
