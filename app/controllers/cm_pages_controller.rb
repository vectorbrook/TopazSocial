class CmPagesController < ApplicationController

  before_filter :check_role, :only => [:index, :show, :new, :edit, :create, :update]

  def check_role
    is_user? || is_employee?
  end


  def index
    cond_ = {}
    if params[:r]
      cond_ = {:title => /#{params[:r]}/i }
      @cm_pages = CmPage.where(cond_).order_by('title DESC').page params[:page]
    else

      @cm_pages = CmPage.order_by('title DESC').page params[:page]
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cm_pages }
    end
  end

  # GET /cm_pages/1
  # GET /cm_pages/1.xml
  def show
    @cm_page = CmPage.find_by_slug(params[:id])

    session[:back_to] = cm_page_path(@cm_page)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cm_page }
    end
  end

  # GET /cm_pages/new
  # GET /cm_pages/new.xml
  def new
    @category = (CmPageCategory.find params[:cm_page_category] if params[:cm_page_category]) || CmPageCategory.first
    @cm_page = CmPage.new(:cm_page_category => @category)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cm_page }
    end
  end

  # GET /cm_pages/1/edit
  def edit
    @cm_page = CmPage.find_by_slug(params[:id])
  end

  # POST /cm_pages
  # POST /cm_pages.xml
  def create
    @cm_page = CmPage.new(params[:cm_page])
    @cm_page.user = current_user

    respond_to do |format|
      if @cm_page.save
        format.html { redirect_to(:action => :index) }
        format.xml  { render :xml => @cm_page, :status => :created, :location => @cm_page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cm_page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cm_pages/1
  # PUT /cm_pages/1.xml
  def update
    @cm_page = CmPage.find_by_slug(params[:id])

    respond_to do |format|
      if @cm_page.update_attributes(params[:cm_page])
        format.html { redirect_to(@cm_page) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cm_page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cm_pages/1
  # DELETE /cm_pages/1.xml
  def destroy
    @cm_page = CmPage.find_by_slug(params[:id])
    @cm_page.destroy

    respond_to do |format|
      format.html { redirect_to(cm_pages_url) }
      format.xml  { head :ok }
    end
  end

  def approve
    @cm_page = CmPage.find_by_slug(params[:id])
    @cm_page.save! if @cm_page.try(:approve,current_user)
    redirect_to pending_approvals_path
  end

   def disapprove
    @cm_page = CmPage.find_by_slug(params[:id])
    @cm_page.save! if @cm_page.try(:disapprove,current_user)
    redirect_to pending_approvals_path
  end

  def enable
    @cm_page = CmPage.find_by_slug(params[:id])
    @cm_page.save! if @cm_page.try(:enable,current_user)
    redirect_to @cm_page.forum
  end

   def disable
    @cm_page = CmPage.find_by_slug(params[:id])
    @cm_page.save! if @cm_page.try(:disable,current_user)
    redirect_to @cm_page.forum
  end

end
