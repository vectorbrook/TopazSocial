class CustomerAccountsController < ApplicationController
  
  load_and_authorize_resource
  
  # GET /customer_accounts
  # GET /customer_accounts.xml
  def index
    #@customer_accounts = CustomerAccount.all
    cond_ = {}
    if params[:r]
      cond_ = {:name => /#{params[:r]}/i }
    end
    @customer_accounts = CustomerAccount.paginate :page => params[:page], :order => 'created_at DESC' , :conditions => cond_

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @customer_accounts }
      format.js 
    end
  end

  # GET /customer_accounts/1
  # GET /customer_accounts/1.xml
  def show
    @customer_account = CustomerAccount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @customer_account }
    end
  end

  # GET /customer_accounts/new
  # GET /customer_accounts/new.xml
  def new
    @customer_account =  CustomerAccount.new
    @customer_site = CustomerSite.new#(:customer_account => @customer_account)
    @customer_contact = CustomerContact.new#(:site => @site)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @customer_account }
    end
  end

  # GET /customer_accounts/1/edit
  def edit
    @customer_account = CustomerAccount.find(params[:id])
  end

  # POST /customer_accounts
  # POST /customer_accounts.xml
  def create
    begin
      
      @customer_account = CustomerAccount.new(params[:customer_account])
      @customer_account.save!
      @customer_site = CustomerSite.new(params[:customer_account][:customer_site])
      @customer_site.customer_account = @customer_account
      @customer_site.save!
      @customer_contact = CustomerContact.new(params[:customer_account][:customer_contact])
      @customer_contact.customer_site = @customer_site
      @customer_contact.save!
      
      respond_to do |format|
        format.html { redirect_to(customer_accounts_path) }
        format.xml  { render :xml => @customer_account, :status => :created, :location => @customer_account }      
      end
      
    rescue Exception => e
      
      p "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
      p e.message
      @customer_contact.try(:delete)
      @customer_site.try(:delete)
      @customer_account.try(:delete)
      
      @customer_contact = CustomerContact.new(params[:customer_account][:customer_contact])
      @customer_site = CustomerSite.new(params[:customer_account][:customer_site])
      @customer_account = CustomerAccount.new(params[:customer_account])
      
      respond_to do |format|
        format.html { render :action => "new" }
        format.xml  { render :xml => @customer_account.errors, :status => :unprocessable_entity }
      end
      
    end    
    
  end

  # PUT /customer_accounts/1
  # PUT /customer_accounts/1.xml
  def update
    @customer_account = CustomerAccount.find(params[:id])

    respond_to do |format|
      if @customer_account.update_attributes(params[:customer_account])
        format.html { redirect_to(customer_accounts_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @customer_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_accounts/1
  # DELETE /customer_accounts/1.xml
  def destroy
    @customer_account = CustomerAccount.find(params[:id])
    @customer_account.destroy

    respond_to do |format|
      format.html { redirect_to(customer_accounts_url) }
      format.xml  { head :ok }
    end
  end
  
  def enable
    @customer_account = CustomerAccount.find(params[:id])
    @customer_account.save! if @customer_account.try(:enable,current_user)
    redirect_to customer_accounts_path  
  end
  
   def disable
    @customer_account = CustomerAccount.find(params[:id])
    @customer_account.save! if @customer_account.try(:disable,current_user)
    redirect_to customer_accounts_path
  end
  
end
