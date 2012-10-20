class SessionsController < ApplicationController  

  skip_authorization_check :only => :destroy
  #load_and_authorize_resource

  def destroy
    #skip_authorization_check
    #authorize! :sign, :out
    session.clear
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end

end

