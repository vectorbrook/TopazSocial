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


class ContactsController < ApplicationController
 before_filter :require_admin
  # GET /accounts
  # GET /accounts.xml
  def index
    @contacts = Contact.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contacts }
    end
  end

  # GET /sites/1
  # GET /sites/1.xml
  def show
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /sites/new
  # GET /sites/new.xml
  def new
    @account = Account.find params[:account_id]
    @site = Site.find params[:site_id] 
    @contact = Contact.new(:site => @site)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /sites/1/edit
  def edit
    @account = Account.find params[:account_id]
    @site = Site.find params[:site_id] 
    @contact = Contact.find(params[:id])
  end

  # POST /sites
  # POST /sites.xml
  def create
    @contact = Contact.new(params[:contact])
    #@contact.user = current_user

    respond_to do |format|
      if @contact.save
        format.html { redirect_to( account_site_path @contact.site.account , @contact.site ) }
        format.xml  { render :xml => @contact, :status => :created, :location => @contact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sites/1
  # PUT /sites/1.xml
  def update
    @contact = Contact.find(params[:id])
    @site = @contact.site

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to(account_site_path @contact.site.account , @contact.site) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.xml
  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(sites_url) }
      format.xml  { head :ok }
    end
  end
  
  def enable
     @contact = Contact.find(params[:id])
    @contact.save! if @site.try(:enable,current_user)
    redirect_to @site.account  
  end
  
   def disable
     @contact = Contact.find(params[:id])
    @contact.save! if @site.try(:disable,current_user)
    redirect_to @site.account  
  end
  
end
