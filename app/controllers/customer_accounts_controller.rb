class CustomerAccountsController < ApplicationController
  before_action :set_customer_account, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, :only => [:index, :show, :new, :edit, :create, :update]


  # GET /customer_accounts
  # GET /customer_accounts.json
  def index
    cond_ = {}
    if params[:r]
      cond_ = {:name => /#{params[:r]}/i }
      @customer_accounts = CustomerAccount.where(cond_).order_by('name DESC').page params[:page]
    else
      @customer_accounts = CustomerAccount.order_by('name DESC').page params[:page]
    end
  end

  # GET /customer_accounts/1
  # GET /customer_accounts/1.json
  def show
  end

  # GET /customer_accounts/new
  def new
    @customer_account = CustomerAccount.new
  end

  # GET /customer_accounts/1/edit
  def edit
  end

  # POST /customer_accounts
  # POST /customer_accounts.json
  def create
    @customer_account = CustomerAccount.new(customer_account_params)

    respond_to do |format|
      if @customer_account.save
        format.html { redirect_to @customer_account, notice: 'Customer account was successfully created.' }
        format.json { render action: 'show', status: :created, location: @customer_account }
      else
        format.html { render action: 'new' }
        format.json { render json: @customer_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customer_accounts/1
  # PATCH/PUT /customer_accounts/1.json
  def update
    respond_to do |format|
      if @customer_account.update(customer_account_params)
        format.html { redirect_to @customer_account, notice: 'Customer account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @customer_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_accounts/1
  # DELETE /customer_accounts/1.json
  def destroy
    @customer_account.destroy
    respond_to do |format|
      format.html { redirect_to customer_accounts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_account
      @customer_account = CustomerAccount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_account_params
      params.require(:customer_account).permit(:name, :description, :ac_type)
    end
end
