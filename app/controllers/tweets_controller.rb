class TweetsController < ApplicationController

  before_action :find_tweet, only: [:destroy]
  def create
    @tweet = Tweet.new(tweet_params)

    if @tweet.save!
      render json: {
        success: true,
        tweet: {
          username: user.username,
          message: @tweet.message
        }
      }

    end
  end

  def index
    @tweets = Tweet.all.order(created_at: :desc)
    render 'tweets/index.json'
  end

  def index_by_user
    @user = User.find_by(username: params[:username])

    if @user
      @tweets = @user.tweets

      render json: {
        id: @tweets.id,
        username: @user.username, # Include the username in each tweet
        message: tweet.message
      }
    else
      render json: {

        success: false
      }
    end
  end

  def destroy
    if current_user && current_user == @tweet.user
      @tweet.destroy
      render json: { success: true}
    else
      render json: { success: false }
    end
  end

  private



  def find_tweet
    @tweet = Tweet.find_by(id: params[:id])

    unless @tweet
      render json: { success: false, message: 'Tweet not found' }
    end
  end


  def tweet_params
    params.require(:tweet).permit(:message)
  end
end
