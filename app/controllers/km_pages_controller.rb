class KmPagesController < ApplicationController
  before_action :set_km_page_category #,only: [:index, :new, :create, :edit, :update]
  #before_filter :check_role, :only => [:index, :show, :new, :edit, :create, :update]

  #def check_role
  #  is_user? || is_employee?
  #end


  def index
    cond_ = {}
    if params[:r]
      cond_ = {:title => /#{params[:r]}/i }
      @km_pages = @km_page_category.km_pages.where(cond_).order_by('title DESC').page params[:page]
    else

      @km_pages = @km_page_category.km_pages.order_by('title DESC').page params[:page]
    end
  end

  # GET /km_pages/1
  # GET /km_pages/1.xml
  def show
    @km_page = @km_page_category.km_pages.find_by_slug(params[:id])
  end

  # GET /km_pages/new
  # GET /km_pages/new.xml
  def new
    @km_page = @km_page_category.km_pages.new
  end

  # GET /km_pages/1/edit
  def edit
    p params
    @km_page = @km_page_category.km_pages.find_by_slug(params[:id])
  end

  # POST /km_pages
  # POST /km_pages.xml
  def create
    @km_page = @km_page_category.km_pages.new(km_page_params)
    @km_page.user = current_user.id

    respond_to do |format|
      if @km_page.save
        format.html { redirect_to km_page_categories_path, notice: 'km pages was successfully created.' }
        format.json { render action: 'show', status: :created, location: @km_page }
      else
        format.html { render action: 'new' }
        format.json { render json: @km_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /km_pages/1
  # PUT /km_pages/1.xml
  def update
    p params
    @km_page = @km_page_category.km_pages.find_by_slug(params[:id])
    respond_to do |format|
      if @km_page.update(km_page_params)
        format.html { redirect_to km_page_category_km_pages_path(@km_page_category,@km_page), notice: 'km page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @km_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /km_pages/1
  # DELETE /km_pages/1.xml
  def destroy
    @km_page = @km_page_category.km_pages.find_by_slug(params[:id])
    @km_page.destroy

    respond_to do |format|
      format.html { redirect_to km_page_category_km_pages_path(@km_page_category,@km_page) }
      format.json { head :no_content }
    end
  end

  def approve
    @km_page = kmPage.find_by_slug(params[:id])
    @km_page.save! if @km_page.try(:approve,current_user)
    redirect_to pending_approvals_path
  end

   def disapprove
    @km_page = KmPage.find_by_slug(params[:id])
    @km_page.save! if @km_page.try(:disapprove,current_user)
    redirect_to pending_approvals_path
  end

  def enable
    @km_page = KmPage.find_by_slug(params[:id])
    @km_page.save! if @km_page.try(:enable,current_user)
    redirect_to @km_page.forum
  end

   def disable
    @km_page = KmPage.find_by_slug(params[:id])
    @km_page.save! if @Km_page.try(:disable,current_user)
    redirect_to @km_page.forum
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_km_page
      @km_page = @km_page_category.km_pages.where(:id => params[:id]).first
    end

    def set_km_page_category
      @km_page_category = KmPageCategory.where(:id => params[:km_page_category_id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def km_page_params
      params.require(:km_page).permit(:title, :content, :user_id)
    end
end
