class CustomerContactsController < ApplicationController
 
  before_filter :check_role, :only => [:index, :show, :new, :edit, :create, :update]
  def check_role
   is_admin? || is_support_manager?  
  end
  
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
    @customer_site = @customer_account.customer_sites.find(params[:customer_site_id])
    @customer_contact = @customer_site.customer_contacts.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @customer_contact }
    end
  end

  # GET /sites/1/edit
  def edit
    @customer_account = CustomerAccount.find params[:customer_account_id]
    @customer_site = @customer_account.customer_sites.find(params[:customer_site_id])
    @customer_contact = @customer_site.customer_contacts.find(params[:id])
  end

  # POST /sites
  # POST /sites.xml
  def create
    @customer_account = CustomerAccount.find params[:customer_account_id]
    @customer_site = @customer_account.customer_sites.find(params[:customer_site_id])
    @customer_contact = @customer_site.customer_contacts.build(params[:customer_contact])
    #@contact.user = current_user

    respond_to do |format|
      if @customer_contact.save
        contact_user = User.new
        contact_user.name = @customer_contact.full_name
        contact_user.email = @customer_contact.email_addr
        contact_user.role = ["user","customer"]
        contact_user.save(:validate => false)
        @customer_contact.user_id = contact_user.id
        @customer_contact.save
        format.html { redirect_to( customer_account_customer_sites_path(@customer_account) ) }
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
    @customer_account = CustomerAccount.find params[:customer_account_id]
    @customer_site = @customer_account.customer_sites.find(params[:customer_site_id])
    @customer_contact = @customer_site.customer_contacts.find(params[:id])

    respond_to do |format|
      if @customer_contact.update_attributes(params[:customer_contact])
        format.html { redirect_to(customer_account_customer_sites_path(@customer_account)) }
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
    @customer_account = CustomerAccount.find params[:customer_account_id]
    @customer_site = @customer_account.customer_sites.find(params[:customer_site_id])
    @customer_contact = @customer_site.customer_contacts.find(params[:id])
    user = @customer_contact.user
    user.role = ["user"]    
    @customer_site.customer_contacts.delete_if{|p| p.id.to_s == params[:id]}
    @customer_site.save
    user.save
    
    respond_to do |format|
      format.html { redirect_to(customer_account_customer_sites_path(@customer_account)) }
      format.xml  { head :ok }
    end
  end
  
  def enable
    @customer_account = CustomerAccount.find params[:customer_account_id]
    @customer_site = @customer_account.customer_sites.find(params[:customer_site_id])
    @customer_contact = @customer_site.customer_contacts.find(params[:id])
    @customer_contact.save! if @customer_site.try(:enable,current_user)
    redirect_to @customer_site.customer_account  
  end
  
   def disable
    @customer_account = CustomerAccount.find params[:customer_account_id]
    @customer_site = @customer_account.customer_sites.find(params[:customer_site_id])
    @customer_contact = @customer_site.customer_contacts.find(params[:id])
    @customer_contact.save! if @customer_site.try(:disable,current_user)
    redirect_to @customer_site.customer_account  
  end
  
end
