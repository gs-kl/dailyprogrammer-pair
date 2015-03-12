require 'twitter'
require 'redis'
require 'uri'
require 'net/http'

require_relative '../resources/client'
require_relative 'dailyprogrammer_pair/redis'
require_relative 'dailyprogrammer_pair/job'
require_relative 'dailyprogrammer_pair/twitter_client'
require_relative 'dailyprogrammer_pair/tweet_handler'
require_relative 'dailyprogrammer_pair/tweet'
require_relative 'dailyprogrammer_pair/tweet_params'
require_relative 'dailyprogrammer_pair/request_handler'


redis_configuration = {}
redis_client = DailyprogrammerPair::Redis.new(Redis.new(redis_configuration))
twitter_client = DailyprogrammerPair::TwitterClient.new(CLIENT)

while true do
  DailyprogrammerPair::Job.new(redis_client, twitter_client).call
  sleep 5
end
