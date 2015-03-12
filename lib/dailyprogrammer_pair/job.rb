require 'tweet_handler'

module DailyprogrammerPair
  class Job
    attr_reader :redis_client, :twitter_client

    def initialize redis_client, twitter_client
      @redis_client = redis_client
      @twitter_client = twitter_client
    end

    def call
      puts "Initialized job..."
      latest_tweets.each do |tweet|
        TweetHandler.new(redis_client, twitter_client).call(tweet) if redis_client.not_seen?(tweet)
      end
    end

    def latest_tweets
      twitter_client.search("to:tw_gem_test", result_type: "recent").take(10)
    end
  end
end
