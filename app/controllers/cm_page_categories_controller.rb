class CmPageCategoriesController < ApplicationController
  
  before_filter :check_role, :only => [:index, :show, :new, :edit, :create, :update]
  def check_role
   is_admin?
  end

  
  # GET /cm_page_categories
  # GET /cm_page_categories.xml
  def index
    cond_ = {}
    if params[:r]
      cond_ = {:name => /#{params[:r]}/i }
      @cm_page_categories = CmPageCategory.where(cond_).order_by('created_at ASC').page params[:page]
    else
    #@cm_page_categories = CmPageCategory.paginate :page => params[:page], :order => 'created_at ASC' , :conditions => cond_
      @cm_page_categories = CmPageCategory.order_by('created_at ASC').page params[:page]
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cm_page_categories }
    end
  end

  # GET /cm_page_categories/1
  # GET /cm_page_categories/1.xml
  def show
    @cm_page_category = CmPageCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cm_page_category }
    end
  end

  # GET /cm_page_categories/new
  # GET /cm_page_categories/new.xml
  def new
    @cm_page_category = CmPageCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cm_page_category }
    end
  end

  # GET /cm_page_categories/1/edit
  def edit
    @cm_page_category = CmPageCategory.find(params[:id])
  end

  # POST /cm_page_categories
  # POST /cm_page_categories.xml
  def create
    @cm_page_category = CmPageCategory.new(params[:cm_page_category])
    #@category.extract_addsubcategory(params[:page_category][:new_subcat],current_user)

    respond_to do |format|
      if @cm_page_category.save
        format.html { redirect_to(cm_page_categories_path) }
        format.xml  { render :xml => @cm_page_category, :status => :created, :location => @cm_page_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cm_page_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cm_page_categories/1
  # PUT /cm_page_categories/1.xml
  def update
    @cm_page_category = CmPageCategory.find(params[:id])

    respond_to do |format|
      if @cm_page_category.update_attributes(params[:cm_page_category])
        #flag = @category.extract_addsubcategory(params[:page_category][:new_subcat],current_user)
        #flag = @category.extract_remsubcategory(params[:rem_subcat],current_user) || flag
        #if  flag
          #@category.save
        #end
        format.html { redirect_to(cm_page_categories_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cm_page_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cm_page_categories/1
  # DELETE /cm_page_categories/1.xml
  def destroy
    @cm_page_category = CmPageCategory.find(params[:id])
    @cm_page_category.destroy

    respond_to do |format|
      format.html { redirect_to(cm_page_categories_url) }
      format.xml  { head :ok }
    end
  end
  
  def enable
    @cm_page_category = CmPageCategory.find(params[:id])
    @cm_page_category.save! if @cm_page_category.try(:enable,current_user)
    redirect_to cm_page_categories_path  
  end
  
   def disable
    @cm_page_category = CmPageCategory.find(params[:id])
    @cm_page_category.save! if @cm_page_category.try(:disable,current_user)
    redirect_to cm_page_categories_path
  end
  
end
