require 'twitter'
require 'redis'
require 'uri'
require 'net/http'

require_relative 'resources/client'
require_relative 'dailyprogrammer_pair/redis'
require_relative 'dailyprogrammer_pair/job'




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



redis_configuration = {}
redis_client = DailyprogrammerPair::Redis.new(Redis.new(redis_configuration))
twitter_client = DailyprogrammerPair::TwitterClient.new(CLIENT)

while true do
  DailyprogrammerPair::Job.new(redis_client, twitter_client).call
  sleep 5
end
