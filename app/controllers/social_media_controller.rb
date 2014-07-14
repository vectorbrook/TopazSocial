class SocialMediaController < ApplicationController
  
  before_filter :require_user
  
  def social
    @twitter_avlbl = false
    if current_user and session[:twitter_token] and !session[:twitter_token].blank?
      @twitter_avlbl = true
      @lists = []
      @lists = current_user.twitter_client.mentions
    end
  end
  
  def do_tweet
    if current_user and session[:twitter_token] and !session[:twitter_token].blank? and !params[:content].blank?
      current_user.twitter_client.update(params[:content])
    end
    redirect_to social_path
  end
  
end
