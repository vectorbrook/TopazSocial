# Topaz Social
# Copyright (C) 2011 by Vector Brook
#
#
# This file is part of Topaz Social.
#
# Topaz Social is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Topaz Social is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Topaz Social.  If not, see <http://www.gnu.org/licenses/agpl-3.0.html>.


class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :require_admin , :only => [:new,:create,:cancel]
  skip_before_filter :require_no_authentication
  
  # POST /resource/sign_up
  def create
    build_resource
    if is_admin?
      resource.role = Util.add_default_roles(resource.role)
    end
    if resource.save
      set_flash_message :notice, :signed_up
      #sign_in_and_redirect(resource_name, resource)
      redirect_to root_url
    else
      clean_up_passwords(resource)
      render_with_scope :new
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
      render_with_scope :edit
    end
    
  end
  
end
