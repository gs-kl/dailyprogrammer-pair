module DailyprogrammerPair
  class TwitterClient
    attr_reader :client

    def initialize client
      @client = client
    end

    def latest_tweets
      client.search("to:tw_gem_test", result_type: "recent").take(10).map do |tweet|
        DailyprogrammerPair::Tweet.new(tweet)
      end
    end

    def update *args
      client.update args
    end
  end
end
