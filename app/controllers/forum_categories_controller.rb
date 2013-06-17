class ForumCategoriesController < ApplicationController

  before_filter :check_role, :only => [:index, :show, :new, :edit, :create, :update]

  def check_role
    is_admin?
  end

  # GET /categories
  # GET /categories.xml
  def index
    #@categories = ForumCategory.all
    cond_ = {}
    if params[:r]
      cond_ = {:name => /#{params[:r]}/i }
      @categories = ForumCategory.where(cond_).order_by('created_at DESC').page params[:page]
    else
      @categories = (ForumCategory.order_by('created_at DESC').page params[:page]) || []
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = ForumCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = ForumCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = ForumCategory.find(params[:id])
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = ForumCategory.new(params[:forum_category])
    @category.extract_addsubcategory(params[:forum_category][:new_subcat],current_user)

    respond_to do |format|
      if @category.save
        format.html { redirect_to(forum_categories_path) }
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
    @category = ForumCategory.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:forum_category])
        flag = @category.extract_addsubcategory(params[:forum_category][:new_subcat],current_user)
        flag = @category.extract_remsubcategory(params[:rem_subcat],current_user) || flag
        if  flag
          @category.save
        end
        format.html { redirect_to(forum_categories_path) }
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
    @category = ForumCategory.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to(forum_categories_url) }
      format.xml  { head :ok }
    end
  end

  def enable
    @category = ForumCategory.find(params[:id])
    @category.save! if @category.try(:enable,current_user)
    redirect_to forum_categories_path
  end

   def disable
    @category = ForumCategory.find(params[:id])
    @category.save! if @category.try(:disable,current_user)
    redirect_to forum_categories_path
  end

end
