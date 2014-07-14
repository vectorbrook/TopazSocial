class WelcomeController < ApplicationController
   def welcome
   end

  def quick_find
    p  params
    if params[:res] and params[:res] != "welcome"
      redirect_to url_for(:action => 'index' , :controller => params[:res] , :r => params[:r].strip )
    else
      redirect_to root_path
    end
  end

end
