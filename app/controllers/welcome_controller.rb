class WelcomeController < ApplicationController
  #skip_authorize_resource :only => :welcome  
  skip_authorization_check :only => :welcome
  
  def welcome
    #authorize! :welcome, :everyone
    #skip_authorization_check 
  end
  
  def quick_find
    authorize! :quick, :find
    if params[:res] and params[:res] != "welcome"
      redirect_to url_for(:action => 'index' , :controller => params[:res] , :r => params[:r].strip )
    else
      redirect_to root_path
    end    
  end

end
