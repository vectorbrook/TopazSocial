class CustomerContactsController < ApplicationController
  before_action :set_customer_account
  before_action :set_customer_site
  before_action :set_customer_contact, only: [:show, :edit, :update, :destroy]

  before_action :require_admin, :only => [:index, :show, :new, :edit, :create, :update]
  # GET /customer_contacts
  # GET /customer_contacts.json
  def index
    @customer_contacts = @customer_site.customer_contacts.order_by('name DESC').page params[:page]
  end

  # GET /customer_contacts/1
  # GET /customer_contacts/1.json
  def show
  end

  # GET /customer_contacts/new
  def new
    @customer_contact = @customer_site.customer_contacts.new
  end

  # GET /customer_contacts/1/edit
  def edit
  end

  # POST /customer_contacts
  # POST /customer_contacts.json
  def create
    @customer_contact = @customer_site.customer_contacts.new(customer_contact_params)

    respond_to do |format|
      if @customer_contact.save
        @customer_contact =  @customer_contact.create_user(:name => @customer_contact.first_name, :email => @customer_contact.email_addr, :category => CUSTOMER_CATEGORY, :role => [CUSTOMER_ROLES_DEFAULT])  
        p "111111"
        p @customer_contact
        p "2222222"
        @customer_contact.save  
        format.html { redirect_to customer_account_customer_site_customer_contacts_path(@customer_account, @customer_site), notice: 'Customer contact was successfully created.' }
        format.json { render action: 'show', status: :created, location: @customer_contact }
      else
        format.html { render action: 'new' }
        format.json { render json: @customer_contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customer_contacts/1
  # PATCH/PUT /customer_contacts/1.json
  def update
    respond_to do |format|
      if @customer_contact.update(customer_contact_params)
        format.html { redirect_to customer_account_customer_site_customer_contacts_path(@customer_account, @customer_site), notice: 'Customer contact was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @customer_contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_contacts/1
  # DELETE /customer_contacts/1.json
  def destroy
    @customer_contact.destroy
    respond_to do |format|
      format.html { redirect_to customer_account_customer_sites_path(@customer_account) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_account
      @customer_account = CustomerAccount.find(params[:customer_account_id])
    end

    def set_customer_site
      @customer_site = @customer_account.customer_sites.where(:id => params[:customer_site_id]).first
    end
    
    def set_customer_contact
      @customer_contact = @customer_site.customer_contacts.where(:id => params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_contact_params
      params.require(:customer_contact).permit(:first_name, :last_name, :phone_number1, :phone_number2, :phone_number3, :fax_number, :email_addr, :sell_to, :ship_to, :bill_to, :user_id)
    end
end
