class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: :index
  require 'json'

  # GET /tweets
  # GET /tweets.json
  def index
    @q = Tweet.ransack(params[:q])
    @tweets = @q.result(distinct: true).order('created_at DESC').page(params[:page]).per(50)
    @tweet = Tweet.new
  end

  def like
    if current_user
      @tweet = Tweet.find(params[:tweet_id])
      if is_liked?
        @tweet.remove_like(current_user)
      else
        @tweet.add_like(current_user)
      end
    else
      redirect_to new_session_path
    end
    redirect_to root_path
  end

  def retweet
    if current_user
      @tweet = Tweet.find(params[:tweet_id])
      Tweet.create(content: @tweet.content, user_id: current_user.id, origin_tweet: @tweet.id)
    else
      redirect_to new_session_path
    end
    redirect_to root_path
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
  end

  # GET /tweets/1/edit
  def edit
  end

  # POST /tweets
  # POST /tweets.json
  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.user = current_user
    @tweet.content = @tweet.content.split(" ").map(&:to_s)
    @content = JSON.parse(@tweet.content)
    @content.each do |hash|
      if hash.include?('#')
        @name_link = hash.remove("#")
        @new_link = "https://es.wikipedia.org/wiki/#{@name_link}"
        @content[@content.index(hash)] = @new_link
        @tweet.content = @content.join(' ')
      else
        @new_content = @content.join(' ')
        @tweet.content = @new_content
      end     
    end


    respond_to do |format|
      if @tweet.save
        format.html { redirect_to @tweet, notice: 'Tweet was successfully created.' }
        format.json { render :show, status: :created, location: @tweet }
      else
        format.html { render :new }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tweets/1
  # PATCH/PUT /tweets/1.json
  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to @tweet, notice: 'Tweet was successfully updated.' }
        format.json { render :show, status: :ok, location: @tweet }
      else
        format.html { render :edit }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to tweets_url, notice: 'Tweet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def is_liked?
      Like.where(user: current_user.id, tweet: params[:tweet_id]).exists?
    end

    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tweet_params
      params.require(:tweet).permit(:content, :user_id, :origin_tweet)
    end
end
