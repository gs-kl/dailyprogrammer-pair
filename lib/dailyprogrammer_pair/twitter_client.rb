module DailyprogrammerPair
  class TwitterClient
    attr_reader :client

    def initialize client
      @client = client
    end

    def latest_tweets
      client.search("to:tw_gem_test", result_type: "recent").take(30).map do |tweet|
        DailyprogrammerPair::Tweet.new(tweet)
      end
    end

    def update *args
      client.send(:update, *args)
    end
  end
end
