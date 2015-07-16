class User < ActiveRecord::Base

  # score_i => integer score
  # score_f => float score

require 'rubygems'
require 'twitter'

  
  def new_user?
  end

@handle = User.last

  def start_parse

    
    #add narcessistic terms to the array to get  more accurate score

    array = ["i", "I", "me", "Me", "my", "My", "myself", "Myself", "I'm", "i'm", "mine", "Mine"]

    tweets = []

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "6ARIwHcW5efqKeCC2Bm3O9EH9"
      config.consumer_secret     = "cXSog0qnbtEqsgmV7a4bYX9uKoTetDU7TvinPY7737TNXKqmv6"
      config.access_token        = "18218718-2GXaJ9HQ8xhdqZbcilCAXXQexuVcdrfMFjA8O8xyQ"
      config.access_token_secret = "fS0NBEqzFLYLvxuFRkxcMjMQlA0gS1Dzq0t36zmCGYaij"
    end


    def collect_with_max_id(collection=[], max_id=nil, &block)
      response = yield(max_id)
      collection += response
      response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
    end

    def client.get_all_tweets(user)

    begin
      collect_with_max_id do |max_id|
        options = {count: 200, include_rts: true}
        options[:max_id] = max_id unless max_id.nil?
        user_timeline(user, options)
        end
        rescue Twitter::Error::TooManyRequests => error
        # NOTE: Your process could go to sleep for up to 15 minutes but if you
        # retry any sooner, it will almost certainly fail with the same exception.
        sleep error.rate_limit.reset_in + 1
        retry
      end
    end

    @tweets = client.get_all_tweets("#{@handle}")

    tweet_text = []
    @tweets.each do |tweet|
      tweet_text << tweet.text.split
    end

    match = []
    total = 0

    tweet_text.each do |word|
      word.each do |w|
      total += 1
        if array.include?(w)
          match << word
        end
      end
    end
    
      @score =  (match.count.to_f / total.to_f)
    
  end

  
  @handle.start_parse
  @handle.score_f = @score



  
end
