class CustomerSitesController < ApplicationController

  before_filter :check_role, :only => [:index, :show, :new, :edit, :create, :update]
  def check_role
   is_admin? || is_support_manager?  
  end
  # GET /accounts
  # GET /accounts.xml
  def index
    @customer_account = CustomerAccount.find params[:customer_account_id]
    @customer_sites = @customer_account.customer_sites

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @customer_sites }
    end
  end

  # GET /sites/1
  # GET /sites/1.xml
  def show
    @customer_account = CustomerAccount.find params[:customer_account_id]
    @customer_site = @customer_account.customer_sites.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @customer_site }
    end
  end

  # GET /sites/new
  # GET /sites/new.xml
  def new
    @customer_account = CustomerAccount.find params[:customer_account_id]
    @customer_site = @customer_account.customer_sites.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @customer_site }
    end
  end

  # GET /sites/1/edit
  def edit
    @customer_account = CustomerAccount.find params[:customer_account_id]
    @customer_site = @customer_account.customer_sites.find(params[:id])
  end

  # POST /sites
  # POST /sites.xml
  def create
    @customer_account = CustomerAccount.find(params[:customer_account_id])
    @customer_site = @customer_account.customer_sites.build(params[:customer_site])

    respond_to do |format|
      if @customer_site.save
        format.html { redirect_to(customer_accounts_path) }
        format.xml  { render :xml => @customer_site, :status => :created, :location => @customer_site }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @customer_site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sites/1
  # PUT /sites/1.xml
  def update
    @customer_account = CustomerAccount.find params[:customer_account_id]
    @customer_site = @customer_account.customer_sites.find(params[:id])

    respond_to do |format|
      if @customer_site.update_attributes(params[:customer_site])
        format.html { redirect_to(customer_account_customer_sites_path(@customer_account)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @customer_site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.xml
  def destroy
    @customer_account = CustomerAccount.find params[:customer_account_id]
    @customer_site = @customer_account.customer_sites.find(params[:id])
    @customer_site.destroy

    respond_to do |format|
      format.html { redirect_to(customer_sites_url) }
      format.xml  { head :ok }
    end
  end
  
  def enable
    @customer_account = CustomerAccount.find params[:customer_account_id]
    @customer_site = @customer_account.customer_sites.find(params[:id])
    @customer_site.save! if @customer_site.try(:enable,current_user)
    redirect_to @customer_site.customer_account  
  end
  
   def disable
    @customer_account = CustomerAccount.find params[:customer_account_id]
    @customer_site = @customer_account.customer_sites.find(params[:id])
    @customer_site.save! if @customer_site.try(:disable,current_user)
    redirect_to @customer_site.customer_account  
  end
  
end
