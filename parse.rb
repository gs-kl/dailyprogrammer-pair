class Request
  attr_reader :language, :exercise, :preferences, :look_for    # but what if those don't exist??
  def initialize requester, options
    @requester = requester     # get this from tweet.user.screen_name
    @language, @exercise, @preferences, @look_for = options[:language], options[:exercise], options[:preferences], options[:look_for]
  end
end


# Tweet.text = tweet_text
tweet_text = "@exercismpair #pairme lang: #ruby | ex: clock | pref: screenhero | look_for: 1 hour"
 
Request.new(Tweet.user.screen_name, Tweet.request_params)

@active_requests[@request.requester] = @request  # but this can't really be written to file, would have to convert it




  # remake for syntax:       @exercismpair #pairme lang: #ruby | ex: clock | pref: screenhero | look_for: 1 hour
  #
  # notes: hashtags are optional everywhere, ignored by parser
  #
  # parameters can come in any order
  # lang is the only required parameter.
  # pref accepts anything; can be replaced with `req` parameter, for required
  # look_for tries to understand various kinds of times, this should be added to the users hash
  # if look_for is left off, what does it default to?



=begin

  tweet_text = tweet.text


  
  @params = Hash.new

  if is_pair_request? tweet
    @params[:pair_request] = true
  end

  if LANGUAGE_NAMES.index {|lang| "##{lang}" == tweet.text.split[2]}
    @params[:lang] = tweet.text.split[2].to_s
  end

  if EXERCISE_NAMES.include? tweet.text.split[3]
    @params[:exercise] = tweet.text.split[3]
  end
end


=end
