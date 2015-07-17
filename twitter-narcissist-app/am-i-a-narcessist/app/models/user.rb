class User < ActiveRecord::Base

  # score_i => integer score
  # score_f => float score

require 'rubygems'
require 'twitter'

  
  def current_user
    @handle = User.last
  end

  @handle = User.last
  @all_tweets = nil
  def start_parse
    
    #add narcessistic terms to the array to get  more accurate score
    

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
      
      @handle = User.last
      @all_tweets = client.get_all_tweets("#{@handle.name}")
      parse_tweets(@all_tweets)

  end #end start_parse


  def parse_tweets(tweets)
    tweet_text = []
    array = ["i", "I", "me", "Me", "my", "My", "myself", "Myself", "I'm", "i'm", "mine", "Mine"]
    tweets.each { |tweet| tweet_text << tweet.text.split }

    match = []
    total = 0
    tweet_text.each do |sentence|
      sentence.each do |word|
        total += 1
        if array.include?(word)
          match << word
        end
      end
    end
    calculate_score(match, total)
  end
  
  @@score = nil 

  def calculate_score(matches, total)
    @@score =  (matches.count.to_f / total.to_f)

  end


  # Assuming you want a linear mapping from your first range (1-3) to your second (1000-0, descending), 
  # this will be your function:

  # y = (3 - x) / 2 * 1000
  # where x is the input (1 <= x <= 3) and y is the output (0 <= y <= 1000).

  def run
    current_user.start_parse
    @handle.score_f = @@score.round(5)
    @handle.save

  end

end
