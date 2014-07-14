class ServiceCasesController < ApplicationController
  before_action :set_service_case, only: [:show, :edit, :update, :destroy]
  
  #before_action :check_role, :only => [:index, :unassigned_cases, :assigned_cases, :show, :new, :edit, :create, :update, :destroy, :my_cases, :add_log, :add_interaction, :assign_case]

  before_action :require_employee, :only => [:new, :create, :edit, :update, :destroy]
  before_action :require_service_manager, :only => [:unassigned_cases, :assigned_cases, :assign_case]
  
  def require_employee
    if !(current_user and (current_user.role.include?("employee") || current_user.role.include?("contact")))
      flash[:notice] = "You are not authorized."
      redirect_to root_url
    end
  end
  
  def require_service_manager
    if !(current_user and (current_user.role.include?("service_manager") || current_user.role.include?("admin")))
      flash[:notice] = "You are not authorized."
      redirect_to root_url
    end
  end

  def index
    #@service_cases = ServiceCase.all

    cond_ = {}
    if params[:r]
      cond_ = {:name => /#{params[:r]}/i }
      @service_cases = ServiceCase.where(cond_).order_by('name DESC').page params[:page]
    else
      @service_cases = ServiceCase.order_by('name DESC').page params[:page]
    end
  end

  def unassigned_cases
    #@service_cases = ServiceCase.all 
      cond_ = {}
      if params[:r]
        cond_ = {:name => /#{params[:r]}/i }
         @service_cases = ServiceCase.unassigned.where(cond_).order_by('name DESC').page params[:page]
      else
         @service_cases = ServiceCase.unassigned.order_by('name DESC').page params[:page]
      end
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @service_cases.errors, status: :unprocessable_entity }
    end
    #@service_cases = ServiceCase.unassigned.where(:name => /#{params[:r]}/i).order(:name).page params[:page]
  end

  def assigned_cases
    #@service_cases = ServiceCase.all
      cond_ = {}
      if params[:r]
        cond_ = {:name => /#{params[:r]}/i }
        @service_cases = ServiceCase.assigned.where(cond_).order_by('name DESC').page params[:page]
      else
      #@service_cases = ServiceCase.assigned.where(:name => /#{params[:r]}/i).order(:name).page params[:page]
        @service_cases = ServiceCase.assigned.order_by('name DESC').page params[:page]
      end
     respond_to do |format|
      format.html { render :index }
      format.json { render json: @service_cases.errors, status: :unprocessable_entity }
     end 
  end

  # GET /service_cases/1
  # GET /service_cases/1.xml
  def show
    @service_cases = ServiceCase.find(params[:id])
    #@cust_interaction = ServiceCaseInteraction.new(:service_case => @service_case)
    #@service_case_interaction = @service_case.service_case_interactions.new
    #@service_case_interaction = ServiceCaseInteraction.new(:context => "ServiceCase",:context_id => @service_case.id)
    session[:back_to] = service_case_path(@service_case)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @service_case }
    end
  end

  # GET /service_cases/new
  # GET /service_cases/new.xml
  def new
    @service_case =  ServiceCase.new
  end

  # GET /service_cases/1/edit
  def edit
    @service_case = ServiceCase.find(params[:id])
  end

  # POST /service_cases
  # POST /service_cases.xml
  def create
      p "in create service case controller"
      @service_case = ServiceCase.new(service_case_params)
      @service_case.created_by = current_user.id
      p "service cases are"
      respond_to do |format|
          if @service_case.save
            format.html { redirect_to @service_case, notice: 'service case was successfully created.' }
            #servic = {"_id" => @service_case.id.to_s, "name" => @service_case.name, "description" => @service_case.description, "type" => @service_case.type, "priority" => @service_case.priority, "impact" => @service_case.impact, "status" => @service_case.status, "solution" => @service_case.solution}
            #format.json { render json: servic }
            format.json { render action: 'show', status: :created, location: @service_case }
          else
            format.html { render action: 'new' }
            format.json { render json: @service_case.errors, status: :unprocessable_entity }
          end
      end

  end

  # PUT /service_cases/1
  # PUT /service_cases/1.xml
  def update
    respond_to do |format|
      params[:service_case].delete("account_id")
      params[:service_case][:type] = params[:service_case][:type].to_i
      params[:service_case][:priority] = params[:service_case][:priority].to_i
      if @service_case.update(service_case_params)
        format.html { redirect_to @service_case, notice: 'service case was successfully created.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @service_case.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /service_cases/1
  # DELETE /service_cases/1.xml
  def destroy
    @service_case.destroy

    respond_to do |format|
      format.html { redirect_to @service_case}
      format.json  { head :no_content }
    end
  end

  def enable

    @service_case = ServiceCase.find(params[:id])
    @service_case.save! if @service_case.try(:enable,current_user)
    redirect_to service_cases_path
  end

   def disable

    @service_case = ServiceCase.find(params[:id])
    @service_case.save! if @service_case.try(:disable,current_user)
    redirect_to service_cases_path
  end

  def add_interaction
    if request.post?
      begin
        @service_case = ServiceCase.find(params[:service_case_id])
        @service_case.service_case_interactions.build(
                        :interaction_text => params[:interaction_text],
                        :created_at => Time.now
                        ) if @service_case
        @service_case.try(:save!)
      rescue Exception => e

      end
      redirect_to ( @service_case || root_path )
    else

    end
  end

  def assign_case
    p "11111111"
    if request.post?
      p "2222222"
      begin
        @service_case = ServiceCase.find(params[:service_case_id])
        p "service cases are"
        p @service_case
        @service_case.try(:save!) if @service_case.assign_to(params[:employee])
      rescue Exception => e

      end
      redirect_to ( @service_case || root_path )
    else
      @service_case = ServiceCase.find(params[:id])
      @employees = User.employees.active || []
    end
  end

  def add_log
    if request.post?
      begin
        @service_case = ServiceCase.find(params[:service_case_id])
        @service_case_log = @service_case.service_case_logs.build(:log_text => params[:text], :user_id => current_user.id, :created_at => Time.now) if @service_case
        @service_case_log.try(:save!)
        p @service_case.service_case_logs
        format.html { redirect_to @service_case, notice: 'Log entry was successfully created.' }
      rescue Exception => e
      end
      redirect_to ( @service_case || root_path )
    else
    end
  end

  def my_cases
    p params
    @service_cases = current_user.assigned_service_cases
  end
  
  def set_service_case
    @service_case = ServiceCase.find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def service_case_params
    params.require(:service_case).permit(:name, :description, :type, :priority, :impact, :status, :solution, :created_by, :assigned_to, :customer_account_id, :customer_contact_id, :visible_to,:tags)
  end
  

end
