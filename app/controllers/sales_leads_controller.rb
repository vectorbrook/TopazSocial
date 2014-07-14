class SalesLeadsController < ApplicationController
  before_action :set_sales_lead, only: [:show, :edit, :update, :destroy]
  
  
  before_action :require_sales_manager_engineer, :only => [:new, :create, :edit, :update, :destroy]
  before_action :require_sales_manager, :only => [:unassigned_leads, :assigned_leads, :assign_lead]
    
  def require_sales_manager_engineer
    if !(current_user and (current_user.role.include?("sales_manager") || current_user.role.include?("admin") || current_user.role.include?("sales_engineer")))
      flash[:notice] = "You are not authorized."
      redirect_to root_url
    end
  end
  
  def require_sales_manager
    if !(current_user and (current_user.role.include?("sales_manager") || current_user.role.include?("admin")))
      flash[:notice] = "You are not authorized."
      redirect_to root_url
    end
  end
 

  def index

    cond_ = {}
    if params[:r]
      cond_ = {:name => /#{params[:r]}/i }
      @sales_leads = SalesLead.where(cond_).order_by('name DESC').page params[:page]
    else
      @sales_leads = SalesLead.order_by('name DESC').page params[:page]
    end
  end

  def unassigned_leads
      cond_ = {}
      if params[:r]
        cond_ = {:name => /#{params[:r]}/i }
         @sales_leads = SalesLead.unassigned.where(cond_).order_by('name DESC').page params[:page]
      else
         @sales_leads = SalesLead.unassigned.order_by('name DESC').page params[:page]
      end
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @sales_leads.errors, status: :unprocessable_entity }
    end
  end

  def assigned_leads
      cond_ = {}
      if params[:r]
        cond_ = {:name => /#{params[:r]}/i }
        @sales_leads = SalesLead.assigned.where(cond_).order_by('name DESC').page params[:page]
      else
        @sales_leads = SalesLead.assigned.order_by('name DESC').page params[:page]
      end
     respond_to do |format|
      format.html { render :index }
      format.json { render json: @sales_leads.errors, status: :unprocessable_entity }
     end 
  end

  # GET /sales_opportunities/1
  # GET /sales_opportunities/1.xml
  def show
    @sales_leads = SalesLead.find(params[:id])
    session[:back_to] = sales_opportunity_path(@sales_lead)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sales_opportunities.errors, status: :unprocessable_entity }
    end
  end

  # GET /sales_opportunities/new
  # GET /sales_opportunities/new.xml
  def new
    @sales_lead =  SalesLead.new
  end

  # GET /sales_opportunities/1/edit
  def edit
    @sales_lead = SalesLead.find(params[:id])
  end

  # POST /sales_opportunities
  # POST /sales_opportunities.xml
  def create
      p "in create sales opportunity controller"
      @sales_lead = SalesLead.new(sales_lead_params)
      @sales_lead.created_by = current_user.id
      p "sales opportunities are"
      respond_to do |format|
          if @sales_lead.save
            format.html { redirect_to @sales_lead, notice: 'sales lead was successfully created.' }
            format.json { render action: 'show', status: :created, location: @sales_lead }
          else
            format.html { render action: 'new' }
            format.json { render json: @sales_lead.errors, status: :unprocessable_entity }
          end
      end

  end

  # PUT /sales_opportunities/1
  # PUT /sales_opportunities/1.xml
  def update
    respond_to do |format|
      params[:sales_lead].delete("account_id")
      params[:sales_lead][:type] = params[:sales_lead][:type].to_i
      if @sales_lead.update(sales_lead_params)
        format.html { redirect_to @sales_lead, notice: 'sales lead was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @sales_lead.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sales_opportunities/1
  # DELETE /sales_opportunities/1.xml
  def destroy
    @sales_lead.destroy

    respond_to do |format|
      format.html { redirect_to @sales_lead}
      format.json  { head :no_content }
    end
  end

  def add_lead_interaction
    if request.post?
      begin
        @sales_lead = SalesLead.find(params[:sales_lead_id])
        @sales_lead.sales_lead_interactions.build(
                        :interaction_text => params[:interaction_text],
                        :created_at => Time.now
                        ) if @sales_lead
        @sales_lead.try(:save!)
      rescue Exception => e

      end
      redirect_to ( @sales_lead || root_path )
    else

    end
  end
  
  def add_lead_log
    if request.post?
      begin
        @sales_lead = SalesLead.find(params[:sales_lead_id])
        @sales_lead_log = @sales_lead.sales_lead_logs.build(:log_text => params[:text], :user_id => current_user.id, :created_at => Time.now) if @sales_lead
        @sales_lead_log.try(:save!)
      rescue Exception => e
      end
      redirect_to ( @sales_lead || root_path )
    else

    end
  end

  def assign_lead
    if request.post?
      begin
        @sales_lead = SalesLead.find(params[:sales_lead_id])
        @sales_lead.try(:save!) if @sales_lead.assign_to(params[:employee])
      rescue Exception => e

      end
      redirect_to ( @sales_lead || root_path )
    else
      @sales_lead = SalesLead.find(params[:id])
      @employees = User.employees.active || []
    end
  end


  def my_leads
    p params
    @sales_leads = current_user.assigned_sales_leads
  end
  
  def set_sales_lead
    @sales_lead = SalesLead.find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def sales_lead_params
    params.require(:sales_lead).permit(:first_name, :last_name, :title, :company, :phone_number1, :phone_number2, :phone_number3, :fax_number, :email_addr, :address_line1, :address_line2, :city, :state, :country, :zipcode, :twitter, :linkedin, :facebook, :skype, :source, :description, :type, :status, :created_by, :assigned_to, :customer_account_id, :customer_contact_id, :visible_to,:tags)
  end
  

end
