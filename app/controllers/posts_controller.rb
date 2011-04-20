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


class PostsController < ApplicationController
  before_filter :require_user , :only => ['new','create']
  before_filter :require_admin , :only => ['edit','update','destroy','add_notification']
  # GET /forums
  # GET /forums.xml
  def index
    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /topics/1
  # GET /topics/1.xml
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /topics/new
  # GET /topics/new.xml
  def new
    @forum = Forum.find params[:forum_id]
    @topic = Topic.find params[:topic_id] 
    @post = Post.new(:topic => @topic)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /topics/1/edit
  def edit
    @forum = Forum.find params[:forum_id]
    @topic = Topic.find params[:topic_id] 
    @post = Post.find(params[:id])
  end

  # POST /topics
  # POST /topics.xml
  def create
    @post = Post.new(params[:post])
    @post.user = current_user

    respond_to do |format|
      if @post.save
        format.html { redirect_to( forum_topic_path @post.topic) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.xml
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to(@post.topic) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(topics_url) }
      format.xml  { head :ok }
    end
  end
  
  def approve
    @post = Post.find(params[:id])
    @post.save! if @post.try(:approve,current_user)
    redirect_to pending_approvals_path  
  end
  
   def disapprove
    @post = Post.find(params[:id])
    @post.save! if @topic.try(:disapprove,current_user)
    redirect_to pending_approvals_path  
  end
  
  def enable
     @post = Post.find(params[:id])
    @post.save! if @topic.try(:enable,current_user)
    redirect_to @topic.forum  
  end
  
   def disable
     @post = Post.find(params[:id])
    @post.save! if @topic.try(:disable,current_user)
    redirect_to @topic.forum  
  end
  
  def add_notification
    if request.post?
       @post = Post.find(params[:id])
       @post.try(:add_notification,params[:commentary],current_user)      
      redirect_to pending_forumrovals_path
    else
      @post = Post.find(params[:id])
      if @post
        @notification = Notification.new(:parent_type => "Post" , :parent_id => @post.id, :user => @post.user )
      else
        redirect_to pending_approvals_path
      end      
    end
  end
  
end
