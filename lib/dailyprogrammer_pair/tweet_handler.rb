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
        RequestHandler.new(tweet)
      else
        twitter_client.update("@#{tweet.user.username} I only understand correctly formatted pair requests, and that wasn't one. Check your syntax or tweet at litchk.", in_reply_to_status_id: tweet.id)
        puts "Tweet #{tweet} was not a valid pair request!\n#{tweet.text}"
      end
      redis_client.recent_at_messages.set(tweet.id, true)
    end
  end
end
