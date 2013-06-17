class ForumsController < ApplicationController

  before_filter :require_admin, :except => [:index,:show]

  # GET /forums
  # GET /forums.xml
  def index
    #@forums = Forum.all
    cond_ = {}
    if params[:r]
      cond_ = {:name => /#{params[:r]}/i }
      @forums = Forum.where(cond_).order_by('name DESC').page params[:page]
    else
      @forums = Forum.order_by('name DESC').page params[:page]
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @forums }
    end
  end

  # GET /forums/1
  # GET /forums/1.xml
  def show
    @forum = Forum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @forum }
    end
  end

  # GET /forums/new
  # GET /forums/new.xml
  def new
    @forum =  Forum.new(:forum_category => ( ForumCategory.find( params[:fc_id] )  || nil ) )

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @forum }
    end
  end

  # GET /forums/1/edit
  def edit
    @forum = Forum.find(params[:id])
  end

  # POST /forums
  # POST /forums.xml
  def create
    @forum = Forum.new(params[:forum])

    respond_to do |format|
      if @forum.save
        format.html { redirect_to(forums_path) }
        format.xml  { render :xml => @forum, :status => :created, :location => @forum }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @forum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /forums/1
  # PUT /forums/1.xml
  def update
    @forum = Forum.find(params[:id])

    respond_to do |format|
      if @forum.update_attributes(params[:forum])
        format.html { redirect_to(forums_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @forum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /forums/1
  # DELETE /forums/1.xml
  def destroy
    @forum = Forum.find(params[:id])
    @forum.destroy

    respond_to do |format|
      format.html { redirect_to(forums_url) }
      format.xml  { head :ok }
    end
  end

  def enable
    @forum = Forum.find(params[:id])
    @forum.save! if @forum.try(:enable,current_user)
    redirect_to forums_path
  end

   def disable
    @forum = Forum.find(params[:id])
    @forum.save! if @forum.try(:disable,current_user)
    redirect_to forums_path
  end

  def approve
    @forum = Forum.find(params[:id])
    @forum.save! if @forum.try(:approve,current_user)
    redirect_to forums_path
  end

   def reject
    @forum = Forum.find(params[:id])
    @forum.save! if @forum.try(:disapprove,current_user)
    redirect_to forums_path
  end

end
