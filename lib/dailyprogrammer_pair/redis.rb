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
  end

end
