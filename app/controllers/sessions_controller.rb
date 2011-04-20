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


class SessionsController < ApplicationController
  
  def create
    auth = request.env["omniauth.auth"]
    if current_user
      #case where user is trying to add fb/twitter
      #redirect_to root_url
    else
      user = User.send("find_by_#{auth["provider"]}_uid", auth["uid"]) || User.create_with_omniauth(auth)
      if user
        sign_in(:user, user)
      else
        #redirect_to root_url
      end      
    end
    redirect_to root_url
  end
  
  def destroy
    session.clear
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end

end
