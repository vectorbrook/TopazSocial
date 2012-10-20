class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :require_admin , :only => [:new,:create,:cancel]
  skip_before_filter :require_no_authentication
  
  # POST /resource/sign_up
  def create
    build_resource
    if is_admin?
      resource.role = Util.add_default_roles(resource.role)
    end
    if resource.save(:validate => false)
      set_flash_message :notice, "Employee has been added. Account activation instructions emailed." #:signed_up
      #sign_in_and_redirect(resource_name, resource)
      redirect_to root_url
    else
      clean_up_passwords(resource)
      render :new
    end
  end
  
  # PUT /resource
  def update
    
    params[resource_name]["role"] = Util.add_default_roles(params[resource_name]["role"])
    
    if resource.update_with_password(params[resource_name])
      set_flash_message :notice, :updated
      redirect_to after_update_path_for(resource)
    else
      clean_up_passwords(resource)
      render :edit
    end
    
  end
  
end
