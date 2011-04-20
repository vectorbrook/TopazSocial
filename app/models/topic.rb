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


class Topic
  include MongoMapper::Document
  include AccessControl
  include Enablable
  include Approvable
  include Lockable
  include Permalink

  key :title,            String,    :required => true
  key :hits,             Integer,   :default => 0
  key :sticky,           Integer,   :default => 0
  key :posts_count,      Integer,   :default => 0
  #key :locked,           Boolean,   :default => false
  key :last_post_id,     ObjectId
  key :last_updated_at,  DateTime
  key :last_user_id,     ObjectId
  key :forum_id,         ObjectId,  :required => true
  key :user_id,          ObjectId,  :required => true

  timestamps!

  validate :name_duplicity_within_forum

  privilegify  "admin",       ["all"]
  privilegify  ["approver"],  ["enable","disable","lock","unlock","approve","disapprove"]

  default_privileges ["read","create"]

  has_permalink_on :title , :parent => :forum

  belongs_to :forum
  belongs_to :user
  many :posts

  before_create

  def post_added(post)
    (post and Util.is_What(post,"Post")) ? add_new_post(post) : false
  end

  protected

  def add_new_post(post)
    return false unless status == "active"
    self.posts_count  = self.posts_count + 1
    self.last_post_id = post.id
    return true
  end

  private

  def name_duplicity_within_forum
    name_ = self.title
    topics_ = nil
    topics_ = Topic.where(:title => /#{name_}/i,:forum_id => self.forum.id).all if ( name_ and !name_.empty? )
    if forums_ and !forums_.empty?
      errors.add_to_base("Forum with a same name already exists.")
    end
  end

end

