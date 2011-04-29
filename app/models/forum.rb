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


class Forum
  include MongoMapper::Document
  include Noteable
  include Enablable
  include Approvable
  include AccessControl
  include Permalink

  key :name,               String,    :required => true
  key :description,        String
  key :topics_count,       Integer,   :default => 0
  key :posts_count,        Integer,   :default => 0
  key :position,           Integer,   :default => 0
  key :description_html,   String
  key :state,              String,    :default => "public"
  key :forum_category_id,  ObjectId,  :required => true

  validate :name_duplicity_within_category

  has_permalink_on :name

  belongs_to :forum_category
  many :topics

  attr_accessible :name , :description, :forum_category

  cattr_reader :per_page
  @@per_page = 3

  scope :active,   where(:enabled => true , :approved => true )
  scope :pending,  where(:enabled => true , :approved => false , :approved_by => nil)
  scope :disabled, where(:enabled => false , :approved => true )

  privilegify  "admin",       ["all"]
  privilegify  ["approver"],  ["enable","disable","approve","disapprove"]

  def topic_added(save_=true)
    self.topics_count = self.topics_count + 1
    save if save_
  end

  def post_added(save_=true)

  end

  def category_active
    return self.forum_category.is_enabled?
  end

  def is_active?
    return ( is_approved? and is_enabled? and category_active )
  end

  def status
    if has_been_approved?
      if is_approved?
        if is_enabled?
          if is_active?
            return "Active"
          else
            return "Disabled: Parent Category Disabled"
          end
        else
          return "Disabled"
        end
      else
        return "Disapproved"
      end
    else
      return "Pending"
    end
  end

  private

  def name_duplicity_within_category
    name_ = self.name
    forums_ = nil
    forums_ = Forum.where(:name => /#{name_}/i,:forum_category_id => self.forum_category.id).all if ( name_ and !name_.empty? )
    if forums_ and !forums_.empty?
      errors.add_to_base("Forum with a same name already exists.")
    end
  end

end

