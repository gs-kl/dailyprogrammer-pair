module DailyprogrammerPair
  class TweetHandler
    attr_reader :redis_client, :twitter_client

    def initialize(redis_client, twitter_client)
      @redis_client = redis_client
      @twitter_client = twitter_client
    end

    def call(tweet)
      puts "Handling tweet #{tweet.id}..."
      if tweet.is_pair_request? && tweet.has_link_to_dailyprogrammer?
        puts "Sending tweet to PairRequestHander..."
        PairRequestHander.new(redis_client, twitter_client).call(tweet)
      elsif tweet.is_pair_request?
        puts "Tweet #{tweet} (\"#{tweet.text}\") was not a valid pair request; sending repsonse..."
        twitter_client.update("@#{tweet.user.screen_name} Looks like you wanted to make a pair request, but I didn't understand. Check your syntax.", in_reply_to_status_id: tweet.id)
      # "else" -- if the tweet does not include the "#pairme" hashtag -- no action is taken.
      end
      redis_client.remember(tweet)
    end
  end
end
