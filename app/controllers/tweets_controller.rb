class TweetsController < ApplicationController
  

  def create
  if user_authenticated?
    @tweet = current_user.tweets.build(tweet_params)

    if @tweet.save
      render json: {
        success: true,
        tweet: {
          username: @tweet.user.username,
          message: @tweet.message
        }
      }
    else
      render json: {
        success: false
      }
    end
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
    @user = User.find_by(username: params[:username])

    if @user
      @tweets = @user.tweets.order(created_at: :desc)
      render json: {
        tweets: @tweets.map { |tweet| format_tweet(tweet) }
      }
    else
      redner json: {
        success: false
      }
    end
  end


  def destroy
    @tweet = Tweet.find_by(id: params[:id])

    if @tweet
      if user_authenticated? && @tweet.user == current_user
        if @tweet.destroy
          render json: { success: true }
        else
          render json: { success: false}
        end
      else
        render json: unauthorized_response
      end
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:message)
  end

  def format_tweet(tweet)
    {
      id: tweet.id,
      username: tweet.user.username,
      message: tweet.message
    }
  end

  def user_authenticated?
    current_user.present?
  end

  def unauthorized_response
    if user_authenticated?
      { success: false, errors: 'Unauthorized' }
    else
      { success: false, errors: 'not logged in' }
    end
  end

  def authenticate_user!
    unless user_authenticated?
      render json: { success: false, errors: 'Unauthorized' }
    end
  end


  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
  
