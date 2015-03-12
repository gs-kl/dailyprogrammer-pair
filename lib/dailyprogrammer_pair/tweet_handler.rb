module DailyprogrammerPair
  class TweetHandler
    attr_reader :redis_client, :twitter_client

    def initialize(redis_client, twitter_client)
      @redis_client = redis_client
      @twitter_client = twitter_client
    end

    def call(tweet)
      puts "Handling tweet #{tweet.id}..."
      if tweet.is_pair_request?
        puts "Sending tweet to RequestHandler..."
        RequestHandler.new(redis_client, twitter_client).call(tweet)
      else
        puts "Tweet #{tweet} (\"#{tweet.text}\") was not a valid pair request; sending repsonse..."
        twitter_client.update("@#{tweet.user.screen_name} I only understand (correctly formatted) pair requests. Check your syntax or tweet @litchk.", in_reply_to_status_id: tweet.id)
      end
      redis_client.remember(tweet)
    end
  end
end
