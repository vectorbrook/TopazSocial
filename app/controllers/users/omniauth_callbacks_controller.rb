class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  #before_filter :require_user, :except => ['passthru']

  def auth_create
    auth = request.env["omniauth.auth"]
    flag = false
    if current_user
      if current_user.send("#{auth['provider']}_uid".to_sym) and !current_user.send("#{auth['provider']}_uid".to_sym).blank?
        if current_user.send("#{auth['provider']}_uid".to_sym) == auth["uid"]
          session["#{auth['provider']}_token".to_sym] = auth["credentials"]["token"]
          current_user.send("#{auth['provider']}_token=".to_sym, auth["credentials"]["token"])
          current_user.send("#{auth['provider']}_secret=".to_sym, auth["credentials"]["secret"])
          current_user.save
          #flag = true
        else
          session["#{auth['provider']}_token".to_sym] = nil
          flash[:notice] = "This Twitter account cannot be associated with this account."
        end
      else
        #case where user is trying to add fb/twitter/linked_in
        user_ = User.send("find_by_#{auth["provider"]}_uid", auth["uid"])
        if user_
          session["#{auth['provider']}_token".to_sym] = nil
          flash[:notice] = "This Twitter account is associated with another account."
        else
          session["#{auth['provider']}_token".to_sym] = auth["credentials"]["token"]
          current_user.send("#{auth['provider']}_uid=".to_sym, auth["uid"])
          current_user.send("#{auth['provider']}_profile_url=".to_sym, auth["info"]["urls"]["#{auth["provider"]}".camelize])
          current_user.send("#{auth['provider']}_token=".to_sym, auth["credentials"]["token"])
          current_user.send("#{auth['provider']}_secret=".to_sym, auth["credentials"]["secret"])
          current_user.save
          flash[:notice] = "User account updated."
          #flag = true
        end        
      end
      
    else
      user = User.send("find_by_#{auth["provider"]}_uid", auth["uid"]) || User.create_with_omniauth(auth)
      if user
        user.send("#{auth['provider']}_token=".to_sym, auth["credentials"]["token"])
        user.send("#{auth['provider']}_secret=".to_sym, auth["credentials"]["secret"])
        user.save
        sign_in(:user, user)
        session["#{auth['provider']}_token".to_sym] = auth["credentials"]["token"]
      else
        #redirect_to root_url
      end
    end
    redirect_to (flag ? edit_user_registration_path : social_url)
  end
  
  alias twitter auth_create
    
  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

end

