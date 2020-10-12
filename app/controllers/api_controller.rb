class ApiController < ApplicationController
    include ActionController::HttpAuthentication::Basic::ControllerMethods
    http_basic_authenticate_with name: "test@example.com", password: "123qwe", :except => ["news", "tweet_filter"]
    protect_from_forgery with: :null_session 
    require 'json'

    def news
      #render json: Tweet.last(50)
      @tweets = Tweet.all
      tweets = Tweet.last(50)
      hash_new = tweets.map do |tweet|
        @tweets_likes = Like.where(:tweet_id  => tweet.id)
        @tweet_retweet = Tweet.where(:origin_tweet => tweet.id)
        {
          :id => tweet.id,
          :content => tweet.content,
          :user_id => tweet.user_id,
          :like_count => @tweets_likes.count,
          :retweets_count => @tweet_retweet.count,
          :retweeted_from => @tweet_retweet.count
        }
      end 
      @hash_new = hash_new
      render :json => @hash_new
    end
  
    def tweets_between_dates
      date1 = Date.parse(params[:date1])
      date2 = Date.parse(params[:date2])
      @tweets = Tweet.date_filter(date1, date2)

  
      tweets = Tweet.where(created_at: date1..date2)
      hash_result = tweets.map do |tweet|
        @tweets_likes = Like.where(:tweet_id  => tweet.id)
        @tweet_retweet = Tweet.where(:origin_tweet => tweet.id)
        {
          :id => tweet.id,
          :content => tweet.content,
          :user_id => tweet.user_id,
          :like_count => @tweets_likes.count,
          :retweets_count => @tweet_retweet.count,
          :retweeted_from => @tweet_retweet.count
        }
      end 
      @hash_result = hash_result
      render :json => @hash_result 
    end
    
    def create_tweet
        @tweet = Tweet.create(tweet_params)
        @tweet.save
        render json: @tweet
    end
  
    private
  
    def api_params
      params.require(:api).permit(:date1, :date2)
    end
  
    def tweet_params
      params.require(:tweet).permit(:content)
    end
  
  end