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

    def user
      tweet.user
    end

    def is_pair_request?
      text.include?("#pairme")
    end

    def params
      TweetParams.new(self)
    end

    def has_link_to_dailyprogrammer?
      return false unless params.shortened_url
      url_regex = /https*:\/\/www.reddit.com\/r\/dailyprogrammer\//
      params.expanded_url.match url_regex
    end
  end
end

tweet = Object.new(id: 1, text: 'yo dawg, #pairme')

expect(Tweet.new(tweet).id).to eq(1)
expect(Tweet.new(tweet).is_pair_request?).to be_true
