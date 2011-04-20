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

class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user , *(ALL_ROLES - ["user"]).map { |m| [:"is_#{m}?"] }.flatten
  before_filter :authorize_action
  rescue_from Exception, :with => :rescue_all_exceptions

  def acl_ref
    @acl_ref ||= ACL.instance
  end

  def require_user
    #return current_user ? true : false
    if !current_user
      redirect_to root_url
    end
  end

  (ALL_ROLES - ["user"]).each do |role|
    class_eval <<-METHODS, __FILE__, __LINE__ + 1
      def is_#{role}?
        return current_user ? current_user.is_#{role}? : false
      end
      def require_#{role}
        if !is_#{role}?
          redirect_to root_url
        end
      end
    METHODS
  end

  def rescue_all_exceptions(exception)
    case exception
    when MongoMapper::DocumentNotFound
        flash[:notice] = "The requested resource was not found."
      when ActionController::RoutingError, ActionController::UnknownController, ActionController::UnknownAction
        flash[:notice] =  "Invalid request."
      else
        p exception.message
        p exception.backtrace
        flash[:notice] =   "An internal error has occurred. Sorry for the inconvenience."
    end
    redirect_to root_url
  end

  def authorize_action
    resource_ = Util.resourcify(controller_name)
    action_ = Util.map_action(action_name)
    roles_ = current_user.try(:role)
    if resource_ and action_ and roles_ and !acl_ref.is_permitted(roles_,resource_,action_)
      redirect_to root_url , :notice => "You cannot access this action."
    end
  end

end

