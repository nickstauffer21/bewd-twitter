class TweetsController < ApplicationController
  def create
    if user_authenticated?
      @tweet = current_user.tweets.new(tweet_params)

      if @tweet.save!
        render json: {
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
          render json: { success: false }
        end
      else
        render json: { success: false }
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

  def authenticate_user!
    render json: { success: false, errors: 'Unauthorized' } unless user_authenticated?
  end

  def current_user
    token = cookies.permanent.signed[:twitter_session_token]
    session = Session.find_by(token: token)
    session.user if session
  end
end
