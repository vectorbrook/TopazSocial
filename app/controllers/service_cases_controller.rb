class ServiceCasesController < ApplicationController
  load_and_authorize_resource
  
  # GET /service_cases
  # GET /service_cases.xml
  def index
    #@service_cases = ServiceCase.all
    cond_ = {}
    if params[:r]
      cond_ = {:name => /#{params[:r]}/i }
    end
    @service_cases = ServiceCase.where(:name => /#{params[:r]}/i).order(:name).page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @service_cases }
      format.js
    end
  end
  
  def unassigned_cases
    #@service_cases = ServiceCase.all
    cond_ = {}
    if params[:r]
      cond_ = {:name => /#{params[:r]}/i }
    end
    @service_cases = ServiceCase.unassigned.where(:name => /#{params[:r]}/i).order(:name).page params[:page]

    respond_to do |format|
      format.html { render :index }
      format.xml  { render :xml => @service_cases }
      format.js
    end
  end
  
  def assigned_cases
    #@service_cases = ServiceCase.all
    cond_ = {}
    if params[:r]
      cond_ = {:name => /#{params[:r]}/i }
    end
    @service_cases = ServiceCase.assigned.where(:name => /#{params[:r]}/i).order(:name).page params[:page]

    respond_to do |format|
      format.html { render :index }
      format.xml  { render :xml => @service_cases }
      format.js
    end
  end

  # GET /service_cases/1
  # GET /service_cases/1.xml
  def show
    @service_case = ServiceCase.find(params[:id])
    #@cust_interaction = ServiceCaseInteraction.new(:service_case => @service_case)
    @interactions = @service_case.interactions
    @interaction = Interaction.new(:context => "ServiceCase",:context_id => @service_case.id)
    
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

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service_case }
    end
  end

  # GET /service_cases/1/edit
  def edit
    @service_case = ServiceCase.find(params[:id])
  end

  # POST /service_cases
  # POST /service_cases.xml
  def create
    begin
      
      @service_case = ServiceCase.new(params[:service_case])
      @service_case.created_by = current_user.id
      @service_case.save!
            
      respond_to do |format|
        format.html { redirect_to(service_cases_path) }
        format.xml  { render :xml => @service_case, :status => :created, :location => @service_case }
      end
      
    rescue Exception => e
      
      #p "vvvvvvvvvvvvv"
      #p e.message
      @service_case.try(:delete)
      
      @service_case = ServiceCase.new(params[:service_case])
      
      respond_to do |format|
        format.html { render :action => "new" }
        format.xml  { render :xml => @service_case.errors, :status => :unprocessable_entity }
      end
      
    end
    
  end

  # PUT /service_cases/1
  # PUT /service_cases/1.xml
  def update
    @service_case = ServiceCase.find(params[:id])
    params[:service_case].delete("account_id")
    params[:service_case][:type] = params[:service_case][:type].to_i
    params[:service_case][:priority] = params[:service_case][:priority].to_i

    respond_to do |format|
      if @service_case.update_attributes(params[:service_case])
        format.html { redirect_to(service_cases_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service_case.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /service_cases/1
  # DELETE /service_cases/1.xml
  def destroy
    @service_case = ServiceCase.find(params[:id])
    @service_case.destroy

    respond_to do |format|
      format.html { redirect_to(service_cases_url) }
      format.xml  { head :ok }
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
                        :description => params[:description],
                        :status => params[:status],
                        :solution => params[:solution],
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
    if request.post?
      begin
        @service_case = ServiceCase.find(params[:service_case_id])
        @service_case.try(:save!) if @service_case.assign_to(params[:employee])
      rescue Exception => e
        p "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbssssssssssssssssssssssssssssssssssssss"
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
        @service_case.service_case_logs.build(:log_text => params[:text], :user_id => current_user.id, :created_at => Time.now) if @service_case
        @service_case.try(:save!)
      rescue Exception => e
        
      end
      redirect_to ( @service_case || root_path )
    else
      
    end
  end
  
  def my_cases
    begin
      (@service_cases = current_user.assigned_service_cases) + []
    rescue NoMethodError => e
       @service_cases = [@service_cases]
    end
    @service_cases
  end
  
  
end
