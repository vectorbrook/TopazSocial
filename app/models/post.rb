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


class Post
  include MongoMapper::Document
  include AccessControl
  include Enablable
  include Approvable
  
  key :body, String, :required => true 
  key :body_html, String
  key :user_id, ObjectId
  key :topic_id, ObjectId
  key :forum_id, ObjectId
  #key :enabled, Boolean, :required => true 
  #key :approved, Boolean, :required => true 

  timestamps!
  
  belongs_to :topic
  belongs_to :user
  
end
