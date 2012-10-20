class CustomerContactsController < ApplicationController
 
  load_and_authorize_resource
  
  # GET /accounts
  # GET /accounts.xml
  def index
    @customer_contacts = CustomerContact.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @customer_contacts }
    end
  end

  # GET /sites/1
  # GET /sites/1.xml
  def show
    @customer_contact = CustomerContact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @customer_contact }
    end
  end

  # GET /sites/new
  # GET /sites/new.xml
  def new
    @customer_account = CustomerAccount.find params[:customer_account_id]
    @customer_site = CustomerSite.find params[:customer_site_id] 
    @customer_contact = CustomerContact.new(:customer_site => @customer_site)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @customer_contact }
    end
  end

  # GET /sites/1/edit
  def edit
    @customer_account = CustomerAccount.find params[:customer_account_id]
    @customer_site = CustomerSite.find params[:customer_site_id] 
    @customer_contact = CustomerContact.find(params[:id])
  end

  # POST /sites
  # POST /sites.xml
  def create
    @customer_contact = CustomerContact.new(params[:customer_contact])
    #@contact.user = current_user

    respond_to do |format|
      if @customer_contact.save
        format.html { redirect_to( customer_account_customer_site_path @customer_contact.customer_site.customer_account , @customer_contact.customer_site ) }
        format.xml  { render :xml => @customer_contact, :status => :created, :location => @customer_contact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @customer_contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sites/1
  # PUT /sites/1.xml
  def update
    @customer_contact = CustomerContact.find(params[:id])
    @customer_site = @customer_contact.customer_site

    respond_to do |format|
      if @customer_contact.update_attributes(params[:customer_contact])
        format.html { redirect_to(customer_account_customer_site_path @customer_contact.customer_site.customer_account , @customer_contact.customer_site) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @customer_contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.xml
  def destroy
    @customer_contact = CustomerContact.find(params[:id])
    @customer_contact.destroy

    respond_to do |format|
      format.html { redirect_to(customer_sites_url) }
      format.xml  { head :ok }
    end
  end
  
  def enable
    @customer_contact = CustomerContact.find(params[:id])
    @customer_contact.save! if @customer_site.try(:enable,current_user)
    redirect_to @customer_site.customer_account  
  end
  
   def disable
    @customer_contact = CustomerContact.find(params[:id])
    @customer_contact.save! if @customer_site.try(:disable,current_user)
    redirect_to @customer_site.customer_account  
  end
  
end
