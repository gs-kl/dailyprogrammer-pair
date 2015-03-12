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
      twitter_client.latest_tweets.each do |tweet|
        TweetHandler.new(redis_client, twitter_client).call(tweet) if redis_client.not_seen?(tweet)
      end
    end
  end
end
