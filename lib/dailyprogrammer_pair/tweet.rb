module DailyprogrammerPair
  class Tweet
    attr_reader :tweet

    def initialize tweet
      @tweet = tweet
    end

    def id
      tweet.id
    end

    def text
      tweet.text
    end

    def is_pair_request?
      text.include?("#pairme") && has_link_to_dailyprogrammer?
    end

    def params
      TweetParams.new(self)
    end

    def has_link_to_dailyprogrammer?
      return false unless params.has_shortened_url?
      url_regex = /https*:\/\/www.reddit.com\/r\/dailyprogrammer\//
      params.expanded_url.match url_regex
    end
  end
end
