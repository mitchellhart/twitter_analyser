class User < ActiveRecord::Base

  NARCISSISM_ARRAY = ["i", "I", "me", "Me", "my", "My", "myself", "Myself", "I'm", "i'm", "mine", "Mine"]

  CELEBS_HASH = {
      lenaDunham: 10,
      kanyewest: 9.3,
      kimkardashian: 8.78,
      emwatson: 7.55,
      charlieSheen:  7.08,
      jeffkatzy: 6.245,
      oprah: 5.902,
      aviflombaum: 5.64,
      realDonaldTrump: 4.079,
      billgates: 4.153,
      benedictCumb:  4.103,
      pontifex:  1.918,
      dalailama: 1.156
  }

  @handle = User.last
  @@score = nil 

  def start_parse

    client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["twitter_api_key"]
        config.consumer_secret     = ENV["twitter_key_secret"]
        config.access_token        = ENV["twitter_access_token"]
        config.access_token_secret = ENV["twitter_access_token_secret"]
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
          user_timeline(user, options) # shows an array list of tweet objects
        end
        
      rescue Twitter::Error::TooManyRequests => error
          # NOTE: Your process could go to sleep for up to 15 minutes but if you
          # retry any sooner, it will almost certainly fail with the same exception.
      sleep error.rate_limit.reset_in + 1
      retry
      end # end begin
    end # end get_all_tweets
      
      @handle = User.last
      all_tweets = client.get_all_tweets("#{@handle.name}")
      parse_tweets(all_tweets)

  end #ends start_parse

  def parse_tweets(tweets)
    tweet_text = []
    tweets.each { |tweet| tweet_text << tweet.text.split }
    match = []
    total = 0
    tweet_text.each do |sentence|
      sentence.each do |word|
        total += 1
        if NARCISSISM_ARRAY.include?(word)
          match << word
        end
      end
    end
    calculate_score(match, total)
  end
  
  # helper method for parse_tweets
  def calculate_score(matches, total)
    # divide scores by our highest score for a range of 0 - 1, 
    # then multiply by 10 for our 1-10 scoring.
    @prescore = (matches.count.to_f / total.to_f)
    if matches.count.to_f == 0.0 # if there are no tweets
      @@score = 0 # assign this to be 0 value
    else
      @@score = (matches.count.to_f / total.to_f) / 0.004574170332
    end
  end
  
  def run
    @handle = User.last
    @handle.start_parse
    @handle.score_f = @@score.round(1)
    @handle.save
  end

  def find_closest_celeb
    CELEBS_HASH.min_by { |celeb_handle, score| (score.to_f - self.score_f).abs }
  end


end
