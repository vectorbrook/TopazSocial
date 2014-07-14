class CustomerSitesController < ApplicationController
  before_action :set_customer_account
  before_action :set_customer_site, only: [:show, :edit, :update, :destroy]
  
  before_action :require_admin, :only => [:index, :show, :new, :edit, :create, :update]
  
  # GET /customer_sites
  # GET /customer_sites.json
  def index
     @customer_sites = @customer_account.customer_sites.order_by('name DESC').page params[:page]
  end

  # GET /customer_sites/1
  # GET /customer_sites/1.json
  def show
  end

  # GET /customer_sites/new
  def new
    @customer_site = @customer_account.customer_sites.new
  end

  # GET /customer_sites/1/edit
  def edit
  end

  # POST /customer_sites
  # POST /customer_sites.json
  def create
    @customer_site = @customer_account.customer_sites.new(customer_site_params)

    respond_to do |format|
      if @customer_site.save
        format.html { redirect_to customer_account_customer_sites_path, notice: 'Customer site was successfully created.' }
        format.json { render action: 'show', status: :created, location: @customer_site }
      else
        format.html { render action: 'new' }
        format.json { render json: @customer_site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customer_sites/1
  # PATCH/PUT /customer_sites/1.json
  def update
    respond_to do |format|
      if @customer_site.update(customer_site_params)
        format.html { redirect_to customer_account_customer_sites_path(@customer_account, @customer_site), notice: 'Customer site was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @customer_site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_sites/1
  # DELETE /customer_sites/1.json
  def destroy
    @customer_site.destroy
    respond_to do |format|
      format.html { redirect_to customer_account_customer_sites_path(@customer_account, @customer_site) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_site
      @customer_site = @customer_account.customer_sites.where(:id => params[:id]).first
    end

    def set_customer_account
      @customer_account = CustomerAccount.where(:id => params[:customer_account_id]).first
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_site_params
      params.require(:customer_site).permit(:name, :description, :address_line1, :address_line2, :city, :state, :country, :zipcode)
    end
end
