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


class UsersController < ApplicationController
  before_filter :require_admin , :only => [:employees,:non_employees,:edit_employee]
  before_filter :require_user , :only => [:follow,:unfollow,:remove_follower,:accept,:decline]
  before_filter :require_employee , :only => [:my_cases]
  
  def employees
    @users = User.where(:role => "employee").all
  end
  
  def non_employees
    @users = User.all - User.where(:role => "employee").all
  end
  
  def edit_employee
    @user = User.find params[:id]
    if request.put?
      params[:user]["role"] = Util.add_default_roles(params[:user]["role"])
      if @user.update_attributes(params[:user])
        redirect_to employees_path
      else
        render :edit_employee
      end
    else
      render :edit_employee
    end    
  end
  
  def disable_user
    user = User.find params[:id]
    if user
      user.locked_at = Time.now
      user.save
    end
    if user.is_employee?
      redirect_to employees_path
    else
      redirect_to root_url
    end
  end

  def enable_user
    user = User.find params[:id]
    user.unlock_access! if user
    if user.is_employee?
      redirect_to employees_path
    else
      redirect_to root_url
    end
  end
  
  def my_cases
    begin
      (@service_cases = current_user.assigned_service_cases) + []
    rescue NoMethodError => e
       @service_cases = [@service_cases]
    end
    @service_cases
  end
  
  (%w[follow unfollow remove_follower accept decline]).each do |user_action|
    class_eval <<-METHODS, __FILE__, __LINE__ + 1
      def #{user_action}
        begin
          current_user.try( #{user_action}.to_sym,( params[:id] || nil ) )
        rescue Exception => e
          #TODO
        end
        redirect_to root_url
      end
    METHODS
  end
  
end
