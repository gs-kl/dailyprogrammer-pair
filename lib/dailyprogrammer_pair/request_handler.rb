module DailyprogrammerPair
  class RequestHandler
    attr_reader :redis_client, :twitter_client

    def initialize(redis_client, twitter_client)
      puts "Initalizing RequestHandler..."
      @redis_client = redis_client
      @twitter_client = twitter_client
    end

    def call(tweet)
      puts "Calling RequestHandler for #{tweet.id}"
      if user_name_of_match = redis_client.matching_request_for(tweet)
        puts "Matched with "
        pair tweet, user_name_of_match
      else
        puts "No match found. Adding pair request to DB..."
        redis_client.set_new_pair_request_for(tweet)
        puts "Informing user pair request submitted..."
        twitter_client.update("@#{tweet.user.screen_name}, you've submitted a pair request for #{tweet.params.shortened_url}. I'll tweet at you when you get a match.", in_reply_to_status_id: tweet.id)
      end
    end

    def pair tweet, user_name_of_match
      twitter_client.update("@#{tweet.user.screen_name} and @#{user_name_of_match}, you have been paired for #{tweet.params.shortened_url}! Get in touch and start pairing :)")
      redis_client.delete_match_for(tweet)
    end
  end
end

