class CategoriesController < ApplicationController
  
  load_and_authorize_resource
  
  # GET /categories
  # GET /categories.xml
  def index
    #@categories = Category.all
    cond_ = {}
    if params[:r]
      cond_ = {:name => /#{params[:r]}/i }
    end
    @categories = Category.paginate :page => params[:page], :order => 'created_at DESC' , :conditions => cond_

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(params[:category])
    @category.extract_addsubcategory(params[:category][:new_subcat],current_user)

    respond_to do |format|
      if @category.save
        format.html { redirect_to(categories_path) }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        flag = @category.extract_addsubcategory(params[:category][:new_subcat],current_user)
        flag = @category.extract_remsubcategory(params[:rem_subcat],current_user) || flag
        if  flag
          @category.save
        end
        format.html { redirect_to(categories_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to(categories_url) }
      format.xml  { head :ok }
    end
  end
  
  def enable
    @category = Category.find(params[:id])
    @category.save! if @category.try(:enable,current_user)
    redirect_to categories_path  
  end
  
   def disable
    @category = Category.find(params[:id])
    @category.save! if @category.try(:disable,current_user)
    redirect_to categories_path
  end
  
end
