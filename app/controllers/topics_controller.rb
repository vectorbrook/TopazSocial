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


class TopicsController < ApplicationController
  before_filter :require_user , :only => ['new','create']
  before_filter :require_admin , :only => ['edit','update','destroy','add_notification']
  # GET /forums
  # GET /forums.xml
  def index
    @topics = Topic.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @topics }
    end
  end

  # GET /topics/1
  # GET /topics/1.xml
  def show
    @topic = Topic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/new
  # GET /topics/new.xml
  def new
    @forum = Forum.find params[:forum_id]
    @topic = Topic.new(:forum => @forum)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/1/edit
  def edit
    @topic = Topic.find(params[:id])
    @forum = Forum.find params[:forum_id]
  end

  # POST /topics
  # POST /topics.xml
  def create
    @topic = Topic.new(params[:topic])
    @topic.user = current_user

    respond_to do |format|
      if @topic.save
        format.html { redirect_to(@topic.forum) }
        format.xml  { render :xml => @topic, :status => :created, :location => @topic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.xml
  def update
    @topic = Topic.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.html { redirect_to(@topic.forum) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.xml
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to(topics_url) }
      format.xml  { head :ok }
    end
  end
  
  def approve
    @topic = Topic.find(params[:id])
    @topic.save! if @topic.try(:approve,current_user)
    redirect_to pending_approvals_path  
  end
  
   def disapprove
    @topic = Topic.find(params[:id])
    @topic.save! if @topic.try(:disapprove,current_user)
    redirect_to pending_approvals_path  
  end
  
  def enable
    @topic = Topic.find(params[:id])
    @topic.save! if @topic.try(:enable,current_user)
    redirect_to @topic.forum  
  end
  
   def disable
    @topic = Topic.find(params[:id])
    @topic.save! if @topic.try(:disable,current_user)
    redirect_to @topic.forum  
  end
  
  def add_notification
    if request.post?
      @topic = Topic.find params[:topic_id]
      @topic.try(:add_notification,params[:commentary],current_user)      
      redirect_to pending_forumrovals_path
    else
      @topic = Topic.find params[:id] 
      if @topic
        @notification = Notification.new(:parent_type => "Topic" , :parent_id => @topic.id, :user => @topic.user )
      else
        redirect_to pending_approvals_path
      end      
    end
  end
  
end
