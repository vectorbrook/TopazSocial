class Users::RegistrationsController < Devise::RegistrationsController

  #before_filter :require_admin , :only => [:new,:create,:cancel]
  skip_before_filter :require_no_authentication
  
  # POST /resource/sign_up
  def create
    p "users/registration_controller.rb create"
    p resource_params
    p "00000000"
    build_resource(resource_params)
    p "111"
    p resource
    p "22222"
    if is_admin?
      #resource.role =  [EMPLOYEE_ROLES_DEFAULT]
      resource.role =  resource.role + [EMPLOYEE_ROLES_DEFAULT]
      resource.category = EMPLOYEE_CATEGORY
    end
    if resource.save(:validate => false)
      p "111111111"
      #:signed_up
      p resource
      p "111112222222"
      #sign_in_and_redirect(resource_name, resource)
      redirect_to root_url, :notice => "Employee has been added. Account activation instructions emailed."
      p "2222222"
    else
      clean_up_passwords(resource)
      render :new
    end
  end
  
  # PUT /resource
  def update
    p "users/registration_controller.rb update"
    #params[resource_name]["role"] = Util.add_default_roles(params[resource_name]["role"])
    p "aaaaaaaaaaaaa"
    if resource.update_with_password(resource_params)
      set_flash_message :notice, :updated
      p "bbbbbbbbbbb"
      redirect_to after_update_path_for(resource)
    else
      clean_up_passwords(resource)
      render :edit
    end
    
  end
  
  def resource_params 
     params.require(:user).permit(:email, :password, :current_password, :password_confirmation, :name, :role => []) 
  end
  
end
