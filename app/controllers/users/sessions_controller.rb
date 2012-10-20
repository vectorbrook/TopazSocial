class Users::SessionsController < Devise::SessionsController

  # POST /resource/sign_in
  def create
    resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    session[:twitter_token] = nil
    respond_with resource, :location => after_sign_in_path_for(resource)
  end
  
  # GET /resource/sign_out
  def destroy
    if session[:twitter_token] and current_user
      current_user.twitter_token = ''
      current_user.twitter_secret = ''
      current_user.save
    end    
    signed_in = signed_in?(resource_name)
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :signed_out if signed_in
    #p ApplicationController::TWITTER_ENABLED

    # We actually need to hardcode this, as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name) }
      format.all do
        method = "to_#{request_format}"
        text = {}.respond_to?(method) ? {}.send(method) : ""
        render :text => text, :status => :ok
      end
    end
  end

end

