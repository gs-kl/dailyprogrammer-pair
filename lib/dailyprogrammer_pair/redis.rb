module DailyprogrammerPair
  class Redis
    attr_reader :redis_object

    def initialize redis_object
      @redis_object = redis_object
    end

    def not_seen?(tweet)
      !!!recent_at_messages.get(tweet.id)
    end

    def remember(tweet)
      recent_at_messages.set(tweet.id, true)
    end

    def set_new_pair_request_for(tweet)
      pair_requests.set(tweet.params.expanded_url + ":" + tweet.params.language, tweet.user.screen_name)
      pair_requests.expire(tweet.params.expanded_url + ":" + tweet.params.language, 43200)
    end

    def matching_request_for(tweet)
      puts "Checking for matching request..."
      puts pair_requests.get(tweet.params.expanded_url + ":" + tweet.params.language)
      pair_requests.get(tweet.params.expanded_url + ":" + tweet.params.language)
    end

    def delete_match_for(tweet)
      pair_requests.del(tweet.params.expanded_url + ":" + tweet.params.language)
    end

    private

    def recent_at_messages
      redis_object.select("0")
      redis_object
    end

    def pair_requests
      redis_object.select("1")
      redis_object
    end

  end
end
