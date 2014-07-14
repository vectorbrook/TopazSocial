class SalesOpportunitiesController < ApplicationController
  before_action :set_sales_opportunity, only: [:show, :edit, :update, :destroy]
  
  before_action :require_sales_manager_engineer, :only => [:new, :create, :edit, :update, :destroy]
  before_action :require_sales_manager, :only => [:unassigned_opportunities, :assigned_opportunities, :assign_opportunity]
    
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
      @sales_opportunities = SalesOpportunity.where(cond_).order_by('name DESC').page params[:page]
    else
      @sales_opportunities = SalesOpportunity.order_by('name DESC').page params[:page]
    end
  end

  def unassigned_opportunities
      cond_ = {}
      if params[:r]
        cond_ = {:name => /#{params[:r]}/i }
         @sales_opportunities = SalesOpportunity.unassigned.where(cond_).order_by('name DESC').page params[:page]
      else
         @sales_opportunities = SalesOpportunity.unassigned.order_by('name DESC').page params[:page]
      end
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @sales_opportunities.errors, status: :unprocessable_entity }
    end
  end

  def assigned_opportunities
      cond_ = {}
      if params[:r]
        cond_ = {:name => /#{params[:r]}/i }
        @sales_opportunities = SalesOpportunity.assigned.where(cond_).order_by('name DESC').page params[:page]
      else
        @sales_opportunities = SalesOpportunity.assigned.order_by('name DESC').page params[:page]
      end
     respond_to do |format|
      format.html { render :index }
      format.json { render json: @sales_opportunities.errors, status: :unprocessable_entity }
     end 
  end

  # GET /sales_opportunities/1
  # GET /sales_opportunities/1.xml
  def show
    @sales_opportunities = SalesOpportunity.find(params[:id])
    session[:back_to] = sales_opportunity_path(@sales_opportunity)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sales_opportunities.errors, status: :unprocessable_entity }
    end
  end

  # GET /sales_opportunities/new
  # GET /sales_opportunities/new.xml
  def new
    @sales_opportunity =  SalesOpportunity.new
  end

  # GET /sales_opportunities/1/edit
  def edit
    @sales_opportunity = SalesOpportunity.find(params[:id])
  end

  # POST /sales_opportunities
  # POST /sales_opportunities.xml
  def create
      p "in create sales opportunity controller"
      @sales_opportunity = SalesOpportunity.new(sales_opportunity_params)
      @sales_opportunity.created_by = current_user.id
      p "sales opportunities are"
      respond_to do |format|
          if @sales_opportunity.save
            format.html { redirect_to @sales_opportunity, notice: 'sales opportunity was successfully created.' }
            format.json { render action: 'show', status: :created, location: @sales_opportunity }
          else
            format.html { render action: 'new' }
            format.json { render json: @sales_opportunity.errors, status: :unprocessable_entity }
          end
      end

  end

  # PUT /sales_opportunities/1
  # PUT /sales_opportunities/1.xml
  def update
    respond_to do |format|
      params[:sales_opportunity].delete("account_id")
      params[:sales_opportunity][:type] = params[:sales_opportunity][:type].to_i
      if @sales_opportunity.update(sales_opportunity_params)
        format.html { redirect_to @sales_opportunity, notice: 'sales opportunity was successfully created.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @sales_opportunity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sales_opportunities/1
  # DELETE /sales_opportunities/1.xml
  def destroy
    @sales_opportunity.destroy

    respond_to do |format|
      format.html { redirect_to @sales_opportunity}
      format.json  { head :no_content }
    end
  end

  def add_opportunity_interaction
    if request.post?
      begin
        @sales_opportunity = SalesOpportunity.find(params[:sales_opportunity_id])
        @sales_opportunity.sales_opportunity_interactions.build(
                        :interaction_text => params[:interaction_text],
                        :created_at => Time.now
                        ) if @sales_opportunity
        @sales_opportunity.try(:save!)
      rescue Exception => e

      end
      redirect_to ( @sales_opportunity || root_path )
    else

    end
  end
  
  def add_opportunity_log
    if request.post?
      begin
        @sales_opportunity = SalesOpportunity.find(params[:sales_opportunity_id])
        @sales_opportunity_log = @sales_opportunity.sales_opportunity_logs.build(:log_text => params[:text], :user_id => current_user.id, :created_at => Time.now) if @sales_opportunity
        @sales_opportunity_log.try(:save!)
        p @sales_opportunity.sales_opportunity_logs
      rescue Exception => e
      end
      redirect_to ( @sales_opportunity || root_path )
    else

    end
  end

  def assign_opportunity
    if request.post?
      begin
        @sales_opportunity = SalesOpportunity.find(params[:sales_opportunity_id])
        @sales_opportunity.try(:save!) if @sales_opportunity.assign_to(params[:employee])
      rescue Exception => e

      end
      redirect_to ( @sales_opportunity || root_path )
    else
      @sales_opportunity = SalesOpportunity.find(params[:id])
      @employees = User.employees.active || []
    end
  end


  def my_opportunities
    p params
    @sales_opportunities = current_user.assigned_sales_opportunities
  end
  
  def set_sales_opportunity
    @sales_opportunity = SalesOpportunity.find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def sales_opportunity_params
    params.require(:sales_opportunity).permit(:name, :source, :description, :type, :status, :stage, :probability, :amount, :discount, :currency, :closes_on, :created_by, :assigned_to, :customer_account_id, :customer_contact_id, :visible_to,:tags)
  end
  

end
