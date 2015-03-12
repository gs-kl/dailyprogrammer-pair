module DailyprogrammerPair
  class Redis
    attr_reader :redis_object

    def initialize redis_object
      @redis_object = redis_object
    end

    def recent_at_messages
      redis_object.select("0")
      redis_object
    end

    def pair_requests
      redis_object.select("1")
      redis_object
    end

    def not_seen?(tweet)
      redis_object.select("0")
      !!!redis_object.get(tweet.id)
    end

    def set_new_pair_request_for(tweet)
      pair_requests.set(tweet.params.expanded_url, tweet.user.screen_name)
    end

    def matching_request_for(tweet)
      puts "Checking for matching request..."
      puts pair_requests.get(tweet.params.expanded_url)
      pair_requests.get(tweet.params.expanded_url)
    end

    def delete_match_for(tweet)
      pair_requests.del(tweet.params.expanded_url)
    end
  end
end
