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


class AccountsController < ApplicationController
  before_filter :require_admin
  # GET /accounts
  # GET /accounts.xml
  def index
    #@accounts = Account.all
    cond_ = {}
    if params[:r]
      cond_ = {:name => /#{params[:r]}/i }
    end
    @accounts = Account.paginate :page => params[:page], :order => 'created_at DESC' , :conditions => cond_

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
      format.js 
    end
  end

  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    @account = Account.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /accounts/new
  # GET /accounts/new.xml
  def new
    @account =  Account.new
    @site = Site.new#(:account => @account)
    @contact = Contact.new#(:site => @site)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /accounts/1/edit
  def edit
    @account = Account.find(params[:id])
  end

  # POST /accounts
  # POST /accounts.xml
  def create
    begin
      
      @account = Account.new(params[:account])
      @account.save!
      @site = Site.new(params[:account][:site])
      @site.account = @account
      @site.save!
      @contact = Contact.new(params[:account][:contact])
      @contact.site = @site
      @contact.save!
      
      respond_to do |format|
        format.html { redirect_to(accounts_path) }
        format.xml  { render :xml => @account, :status => :created, :location => @account }      
      end
      
    rescue Exception => e
      
      @contact.try(:delete)
      @site.try(:delete)
      @account.try(:delete)
      
      @contact = Contact.new(params[:account][:contact])
      @site = Site.new(params[:account][:site])
      @account = Account.new(params[:account])
      
      respond_to do |format|
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
      
    end    
    
  end

  # PUT /accounts/1
  # PUT /accounts/1.xml
  def update
    @account = Account.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.html { redirect_to(accounts_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.xml
  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to(accounts_url) }
      format.xml  { head :ok }
    end
  end
  
  def enable
    @account = Account.find(params[:id])
    @account.save! if @account.try(:enable,current_user)
    redirect_to accounts_path  
  end
  
   def disable
    @account = Account.find(params[:id])
    @account.save! if @account.try(:disable,current_user)
    redirect_to accounts_path
  end
  
end
