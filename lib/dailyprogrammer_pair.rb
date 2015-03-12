require 'twitter'
require 'redis'
require 'uri'
require 'net/http'

require_relative 'resources/client'
require_relative 'dailyprogrammer_pair/redis'


class Twitter::Tweet
  def is_pair_request?
    self.text.include?("#pairme") && self.has_link_to_dailyprogrammer?
  end

  def params
    TweetParams.new(self)
  end

  def has_link_to_dailyprogrammer?
    if params.has_shortened_url?
      url_regex = /https*:\/\/www.reddit.com\/r\/dailyprogrammer\//
      params.expanded_url.match url_regex
    else
      false
    end
  end
end


class TweetParams
  attr_reader :tweet

  def initialize tweet
    @tweet = tweet
  end

  def has_shortened_url?
    @tweet.text.match(/http:\/\/t.co\/\S*/)
  end

  def shortened_url
    @tweet.text.match(/http:\/\/t.co\/\S*/)[0]
  end

  def expanded_url
    uri = URI(shortened_url)
    Net::HTTP.new(uri.host, uri.port).get(uri.path).header["location"]
  end
end




class Job
  attr_reader :redis

  def initialize redis_configuration
    @redis = DailyprogrammerPair::Redis.new(Redis.new(redis_configuration))
  end

  def call
    puts "Initialized job..."
    CLIENT.search("to:tw_gem_test", result_type: "recent").take(10).each do |tweet|
      TweetHandler.new(tweet) if redis.not_seen?(tweet)
    end
  end
end


class RequestHandler
  attr_reader :tweet

  def initialize(tweet)
    @tweet = tweet
    pair_them if matching_request_exists?
  end

  def matching_request_exists?
  end

#     puts ".@#{tweet.user.screen_name} is looking for a pair for #{tweet.params.shortened_url}"
#     Redis.new.create_new_pair_request_for(tweet)
#     puts tweet.text
  #
end


class TweetHandler
  def initialize(tweet)
    puts "Handling tweet #{tweet.id}..."
    if tweet.is_pair_request?
      RequestHandler.new(tweet)
    else
      CLIENT.update("@#{tweet.user.username} I only understand correctly formatted pair requests, and that wasn't one. Check your syntax or tweet at litchk.", in_reply_to_status_id: tweet.id)
      puts "Tweet #{tweet} was not a valid pair request!\n#{tweet.text}"
    end
    Redis.new.recent_at_messages.set(tweet.id, true)
  end
end


redis_configuration = {}

while true do
  Job.new(redis_configuration).call
  sleep 5
end
