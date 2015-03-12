require 'twitter'
require 'redis'
require 'uri'
require 'net/http'

require_relative 'resources/client'

class Redis
  def recent_at_messages
    self.select("0")
    self
  end

  def pair_requests
    self.select("1")
    self
  end

  def not_seen?(tweet)
    self.select("0")
    !!!self.get(tweet.id)
  end
end


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
  def initialize
    puts "Initialized job..."
    CLIENT.search("to:tw_gem_test", result_type: "recent").take(10).each do |tweet|
      TweetHandler.new(tweet) if Redis.new.not_seen?(tweet)
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


while true do
  Job.new
  sleep 5
end
