class KmPageCategoriesController < ApplicationController
  before_action :set_km_page_category, only: [:show, :edit, :update, :destroy]
  before_filter :check_role, :only => [:index, :show, :new, :edit, :create, :update]
  def check_role
   is_admin?
  end

  
  # GET /km_page_categories
  # GET /km_page_categories.xml
  def index
    cond_ = {}
    if params[:r]
      cond_ = {:name => /#{params[:r]}/i }
      @km_page_categories = KmPageCategory.where(cond_).order_by('created_at ASC').page params[:page]
    else
    #@km_page_categories = kmPageCategory.paginate :page => params[:page], :order => 'created_at ASC' , :conditions => cond_
      @km_page_categories = KmPageCategory.order_by('created_at ASC').page params[:page]
    end
  end

  # GET /km_page_categories/1
  # GET /km_page_categories/1.xml
  def show
  end

  # GET /km_page_categories/new
  # GET /km_page_categories/new.xml
  def new
    @km_page_category = KmPageCategory.new
  end

  # GET /km_page_categories/1/edit
  def edit
  end

  # POST /km_page_categories
  # POST /km_page_categories.xml
  def create
    p "111111"
    p params
    p "km_page_category controller"
    @km_page_category = KmPageCategory.new(km_page_category_params)
    #@category.extract_addsubcategory(params[:page_category][:new_subcat],current_user)

    respond_to do |format|
      if @km_page_category.save
        format.html { redirect_to @km_page_category, notice: 'km page category was successfully created.'}
        format.json { render action: 'show', status: :created, location: @km_page_category }
      else
        format.html { render action: 'new' }
        format.json { render json: @km_page_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /km_page_categories/1
  # PUT /km_page_categories/1.xml
  def update 
    p params
    respond_to do |format|
      if @km_page_category.update(km_page_category_params)
        #flag = @category.extract_addsubcategory(params[:page_category][:new_subcat],current_user)
        #flag = @category.extract_remsubcategory(params[:rem_subcat],current_user) || flag
        #if  flag
          #@category.save
        #end
        format.html { redirect_to @km_page_category, notice: 'km page category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @km_page_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /km_page_categories/1
  # DELETE /km_page_categories/1.xml
  def destroy
    @km_page_category.destroy

    respond_to do |format|
      format.html { redirect_to(km_page_categories_url) }
      format.json { head :no_content }
    end
  end
  
  def enable
    @km_page_category = KmPageCategory.find(params[:id])
    @km_page_category.save! if @km_page_category.try(:enable,current_user)
    redirect_to km_page_categories_path  
  end
  
   def disable
    @km_page_category = KmPageCategory.find(params[:id])
    @km_page_category.save! if @km_page_category.try(:disable,current_user)
    redirect_to km_page_categories_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_km_page_category
      @km_page_category = KmPageCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def km_page_category_params
      params.require(:km_page_category).permit(:parent_category_id, :level, :pages, :name, :description)
    end  
end
