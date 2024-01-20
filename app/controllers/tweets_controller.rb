class TweetsController < ApplicationController
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
    else
      render json: {
        success: false
      }
    end
  end

  def index
    @tweets = Tweet.all.order(created_at: :desc)
    render 'tweets/index'
  end

  def index_by_user
  end

  def destroy
  end

  private

  def tweet_params
    params.require(:tweet).permit(:message)
  end
end
